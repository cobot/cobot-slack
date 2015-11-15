class TeamsController < ApplicationController
  before_action :load_space

  def new
    @team = @space.teams.build
  end

  def create
    @team = @space.teams.build team_params
    if (test_response = TeamService.new(@team).auth_test)[:ok]
      @team.save!
      begin
        set_up_webhooks(@team)
        add_existing_members(@team) if @team.invite_existing_members == '1'
        redirect_to @space, flash: {success: "#{@space.name} connected to team #{@team.name}."}
      rescue CobotClient::ResourceNotFound
        @space.destroy
        redirect_to spaces_path, flash: {failure: "Sorry, the space #{@space.name} has been deleted on Cobot."}
      end
    else
      @team.errors.add :slack_token, test_response[:error]
      render 'new'
    end
  end

  def destroy
    team = @space.teams.find params[:id]
    team.destroy
    redirect_to @space, flash: {success: "Team #{team.name} removed from Cobot."}
  end

  private

  def team_params
    params[:team].permit(:slack_token, :slack_url, :name, :invite_existing_members)
  end

  def add_existing_members(team)
    memberships = api_client(@space.admins.first.access_token)
      .get("https://#{@space.subdomain}.cobot.me/api/memberships?attributes=name,email")
    memberships.each do |membership|
      if membership[:email].present?
        TeamService.new(team).invite(membership[:email], membership[:name].to_s)
      end
    end
  end

  def set_up_webhooks(team)
    %w(confirmed_membership connected_user changed_membership_plan).each do |event|
      api_client(current_user.access_token(@space)).post @space.subdomain,
        '/subscriptions', event: event,
        callback_url: space_team_membership_confirmation_url(@space, team)
    end
  end

  def load_space
    @space = current_user.spaces.find params[:space_id]
  end
end
