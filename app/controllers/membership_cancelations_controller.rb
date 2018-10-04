class MembershipCancelationsController < ApplicationController
  before_action :load_space, :load_team
  skip_before_action :authenticate, :verify_authenticity_token

  def create
    membership = begin
      api_client(@space.access_token).get(params[:url])
    rescue RestClient::ResourceNotFound
      nil
    end
    if membership
      if membership[:canceled_to]
        MembershipCancelationWorker.perform_at Time.parse(membership[:canceled_to]),
          @team.id, membership[:email], membership[:name], membership[:id]
      else
        MembershipInviteWorker.perform_async @team.id, membership[:email], membership[:name], membership[:id]
      end
    else
      Rails.logger.info "#{@space.subdomain}: skipped removing member #{params[:url]} - deleted."
    end
    head :ok
  end

  private

  def load_space
    @space = Space.find params[:space_id]
  end

  def load_team
    @team = @space.teams.where(id: params[:team_id]).first || (Rails.logger.info "team #{params[:team_id]} not found for space #{@space.id}/#{@space.subdomain}"; head(410))
  end
end
