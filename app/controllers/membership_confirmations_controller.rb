class MembershipConfirmationsController < ApplicationController
  before_action :load_space, :load_team
  skip_before_action :authenticate, :verify_authenticity_token

  def create
    membership = begin
      api_client(@space.admins.first.access_token).get(params[:url])
    rescue RestClient::ResourceNotFound
      nil
    end
    if membership && membership[:email].present?
      # if
        TeamService.new(@team).invite membership[:email], membership[:name].to_s
        Rails.logger.info "#{@space.subdomain}: subscribed #{membership[:email]} to team."
        head :ok
      # else
      #   head 410
      # end
    else
      if membership
        Rails.logger.info "#{@space.subdomain}: skipped  #{membership[:name]}/#{membership[:id]} as it has no email."
      else
        Rails.logger.info "#{@space.subdomain}: skipped #{params[:url]} as it was deleted."
      end
      head :ok
    end
  rescue RestClient::Forbidden => e
    render json: {error: "Received 403 from Cobot (#{e.response})"}, status: 403
  end

  private

  def load_space
    @space = Space.find params[:space_id]
  end

  def load_team
    @team = @space.teams.where(id: params[:team_id]).first || head(410)
  end
end