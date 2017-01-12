class TeamsController < ApplicationController
  before_action :load_space

  def new
    @team = @space.teams.build name: "#{@space.subdomain} members"
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
    params[:team]
      .permit(:slack_token, :name, :invite_existing_members, :remove_canceled_members)
      .merge(slack_url: ("https://#{params[:team][:slack_url]}.slack.com" if params[:team][:slack_url].present?))
  end

  def add_existing_members(team)
    BulkInviteWorker.perform_async @space.id, team.id
  end

  def set_up_webhooks(team)
    %w(confirmed_membership connected_user).each do |event|
      api_client(@space.access_token).post @space.subdomain,
        '/subscriptions', event: event,
        callback_url: space_team_membership_confirmation_url(@space, team)
    end
    return unless team.remove_canceled_members == '1'
    api_client(@space.access_token).post @space.subdomain,
      '/subscriptions', event: 'canceled_membership',
      callback_url: space_team_membership_cancelation_url(@space, team)
  end

  def load_space
    @space = current_user.spaces.find params[:space_id]
  end
end
