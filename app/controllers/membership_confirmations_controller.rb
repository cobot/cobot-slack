class MembershipConfirmationsController < ApplicationController
  before_action :load_space, :load_team
  skip_before_action :authenticate, :verify_authenticity_token

  def create
    membership = begin
      api_client(@space.access_token).get(params[:url])
    rescue RestClient::ResourceNotFound
      nil
    end
    if membership && membership[:email].present?
      MembershipInviteWorker.perform_async(@team.id, membership)
    else
      if membership
        Rails.logger.info "#{@space.subdomain}: skipped  #{membership[:name]}/#{membership[:id]} as it has no email."
      else
        Rails.logger.info "#{@space.subdomain}: skipped #{params[:url]} as it was deleted."
      end
    end
    head :ok
  rescue RestClient::Forbidden => e
    render json: {error: "Received 403 from Cobot (#{e.response})"}, status: 403
  end

  private

  def load_space
    @space = Space.find params[:space_id]
  end

  def load_team
    @team = @space.teams.where(id: params[:team_id]).first || (Rails.logger.info "team #{params[:team_id]} not found for space #{@space.id}/#{@space.subdomain}"; head(410))
  end
end
