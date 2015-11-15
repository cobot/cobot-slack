class TeamService
  def initialize(team)
    @team = team
  end

  def auth_test
    response = slack_client.auth_test
    response.symbolize_keys
  end

  def invite(email, name)
    slack_client.admin_invite(email: email, first_name: name.scan(/^\S+/).first,
      set_active: true).symbolize_keys
  end

  private

  def slack_client
    @slack_client ||= Slack::Client.new(token: @team.slack_token,
      endpoint: "https://#{@team.slack_url.sub(/^https?\:\/\//, '')}/api")
  end
end
