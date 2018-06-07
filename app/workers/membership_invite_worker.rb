class MembershipInviteWorker
  include Sidekiq::Worker

  def perform(team_id, membership)
    team = Team.find team_id
    TeamService.new(team).invite membership
  end
end
