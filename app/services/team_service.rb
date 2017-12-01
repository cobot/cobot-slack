class TeamService
  def initialize(team)
    @team = team
  end

  def auth_test
    response = slack_client.auth_test
    response.symbolize_keys
  end

  def invite(email, name)
    response = slack_client.admin_invite(email: email, first_name: name.to_s.scan(/^\S+/).first).symbolize_keys
    if response[:ok]
      ActivityWorker.perform_async @team.space_id, I18n.t('team_service.invited', name: name, email: email)
      Rails.logger.info "#{@team.space.subdomain}: invited user #{email}/#{name}"
    else
      ActivityWorker.perform_async @team.space_id,
        I18n.t('team_service.invite_failed', name: name, email: email, error: response[:error].to_s.gsub('_', ' ')),
        'WARN'
      Rails.logger.info "#{@team.space.subdomain}: error inviting #{email}/#{name} to team: #{response}"
    end
    response
  end

  def deactivate(email, name)
    user = slack_client.users_list['members'].find do |u|
      u['profile']['email'] == email || u['profile']['real_name'] == name
    end
    if user
      response = slack_client.admin_set_inactive(user: user['id'])
      Rails.logger.info "#{@team.space.subdomain}: deactivated user #{email}/#{name}: #{response}"
    else
      Rails.logger.info "#{@team.space.subdomain}: cannot deactivate user #{email}/#{name} - not found"
    end
  end

  private

  def slack_client
    @slack_client ||= Slack::Client.new(token: @team.slack_token,
      endpoint: "https://#{@team.slack_url.sub(/^https?\:\/\//, '')}/api")
  end
end
