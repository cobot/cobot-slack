class MembershipCancelationWorker
  include Sidekiq::Worker

  def perform(team_id, email, name)
    team = Team.where(id: team_id).first || return
    TeamService.new(team).deactivate email, name
  end
end
