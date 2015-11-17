require 'rails_helper'

describe 'managing slack teams' do
  context 'when adding a team' do
    before(:each) do
      stub_request(:post, 'https://co-up.cobot.me/api/subscriptions')
        .to_return(body: '{}')
      stub_request(:get, 'https://co-up.cobot.me/api/memberships')
        .to_return(body: [].to_json)
      stub_request(:post, 'https://co-up.slack.com/api/auth.test')
        .to_return(body: {ok: true}.to_json)
      stub_request(:post, 'https://co-up.slack.com/api/users.admin.invite')
        .to_return(body: {ok: true}.to_json)
      @space = log_in 'co.up', access_token: '12345'
    end

    it 'sets up a space for slack integration' do
      add_team name: 'space members'

      expect(page).to have_content('space members')
      %w(confirmed_membership connected_user).each do |event|
        expect(a_request(:post, 'https://co-up.cobot.me/api/subscriptions').with(
          headers: {'Authorization' => 'Bearer 12345'},
          body: {event: event,
            callback_url: space_team_membership_confirmation_url(@space, Team.last)}.to_json
        )).to have_been_made
      end
    end

    it "renders an error if we can't connect to the slack api" do
      stub_request(:post, 'https://co-up.slack.com/api/auth.test')
        .with(body: {token: 'slck-123'})
        .to_return(body: {ok: false, error: 'token invalid'}.to_json)

      add_team name: 'space members', token: 'slck-123'
      expect(page).to have_content('token invalid')
    end

    it 'deletes a space that has been deleted on cobot' do
      stub_request(:post, 'https://co-up.cobot.me/api/subscriptions')
        .to_return(status: 404)

      add_team name: 'space members'

      expect(page).to have_content('space co.up has been deleted')
      visit spaces_path
      expect(page).to have_no_content('co.up')
    end

    it 'invites existing members' do
      stub_request(:get, 'https://co-up.cobot.me/api/memberships?attributes=name,email')
        .with(headers: {'Authorization' => 'Bearer 12345'})
        .to_return(body: [{name: 'joe doe', email: 'joe@doe.com'}].to_json)

      add_team add_existing_members: true, token: 'slack-123'

      expect(a_request(:post, 'https://co-up.slack.com/api/users.admin.invite').with(
        body: {token: 'slack-123', email: 'joe@doe.com',
          first_name: 'joe', set_active: 'true'})
      ).to have_been_made
    end
  end

  it 'removes a team' do
    space = log_in 'co.up'
    space.teams.create! name: 'test team', slack_token: '1', slack_url: 'http://co-up.slack.com'

    visit space_path(space)

    click_link 'Remove'

    expect(page).to have_no_css('.teams', text: 'test list')
  end

  def add_team(name: 'team', token: 't123', add_existing_members: false)
    click_link 'co.up'
    fill_in 'Name', with: name
    fill_in 'Slack Team Token', with: token
    fill_in 'Slack Team URL', with: 'http://co-up.slack.com'
    check 'Invite existing members' if add_existing_members
    click_button 'Add Team'
  end
end
