class MembershipCancelationWorker
  include Sidekiq::Worker

  def perform(team_id, membership)
    team = Team.where(id: team_id).first || return
    TeamService.new(team).deactivate membership['email'], membership['name']
  end
end
