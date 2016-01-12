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
      response = TeamService.new(@team).invite membership[:email], membership[:name].to_s
      handle_slack_response response, membership
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

  def handle_slack_response(response, membership)
    if response[:ok]
      Rails.logger.info "#{@space.subdomain}: subscribed #{membership[:email]} to team."
      head :ok
    else
      Rails.logger.info "#{@space.subdomain}: error subscribing #{membership[:email]} to team: #{response}"
      if response[:error] == 'invalid_auth'
        Rails.logger.info "#{@space.subdomain}: got invalid_auth, would delete team now."
        head :ok
        # @team.destroy
        # head 410
      else
        head :ok
      end
    end
  end

  def load_space
    @space = Space.find params[:space_id]
  end

  def load_team
    @team = @space.teams.where(id: params[:team_id]).first || (Rails.logger.info "team #{params[:team_id]} not found for space #{@space.id}/#{@space.subdomain}"; head(:ok)) # head(410)
  end
end
