class MembershipCancelationWorker
  include Sidekiq::Worker

  def perform(team_id, email, name, membership_id)
    team = Team.where(id: team_id).first || return
    TeamService.new(team).deactivate email, name, membership_id
  end
end
