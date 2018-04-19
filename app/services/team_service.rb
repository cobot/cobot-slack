class TeamService
  def initialize(team)
    @team = team
  end

  def auth_test
    response = slack_client.auth_test
    response.symbolize_keys
  end

  def invite(membership)
    email = membership[:email]
    name = membership[:name]
    response = slack_client.admin_invite(email: email, first_name: name.to_s.scan(/^\S+/).first).symbolize_keys
    if response[:ok]
      Rails.logger.info "#{@team.space.subdomain}: invited user cobot_membership_id: #{membership.id}"
    else
      Rails.logger.info "#{@team.space.subdomain}: error inviting cobot_membership_id: #{membership.id} to team: #{response}"
    end
    response
  end

  def deactivate(membership)
    email = membership[:email]
    name = membership[:name]
    user = slack_client.users_list['members'].find do |u|
      u['profile']['email'] == email || u['profile']['real_name'] == name
    end
    if user
      response = slack_client.admin_set_inactive(user: user['id'])
      Rails.logger.info "#{@team.space.subdomain}: deactivated user cobot_membership_id: #{membership.id}: #{response}"
    else
      Rails.logger.info "#{@team.space.subdomain}: cannot deactivate user cobot_membership_id: #{membership.id} - not found"
    end
  end

  private

  def slack_client
    @slack_client ||= Slack::Client.new(token: @team.slack_token,
      endpoint: "https://#{@team.slack_url.sub(/^https?\:\/\//, '')}/api")
  end
end
