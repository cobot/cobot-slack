class BulkInviteWorker
  include Sidekiq::Worker

  def perform(space_id, team_id)
    space = Space.find space_id
    team = Team.find team_id
    api_client = CobotClient::ApiClient.new(space.access_token)
    memberships = api_client.get("https://#{space.subdomain}.cobot.me/api/memberships?attributes=name,email")
    memberships.each do |membership|
      if membership[:email].present?
        TeamService.new(team).invite(membership[:email], membership[:name].to_s)
      end
    end
  end
end
