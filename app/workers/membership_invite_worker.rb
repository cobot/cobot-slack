class MembershipInviteWorker
  include Sidekiq::Worker

  def perform(team_id, email, name, membership_id)
    team = Team.find team_id
    TeamService.new(team).invite email, name, membership_id
  end
end
