class MembershipCancelationWorker
  include Sidekiq::Worker

  def perform(team_id, membership)
    team = Team.find team_id
    TeamService.new(team).deactivate membership['email'], membership['name']
  end
end
