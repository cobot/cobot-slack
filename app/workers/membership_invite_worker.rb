class MembershipInviteWorker
  include Sidekiq::Worker

  def perform(team_id, email, name)
    team = Team.find team_id
    TeamService.new(team).invite email, name
  end
end
