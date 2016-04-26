require 'rails_helper'

describe 'adding members to slack', type: :request do
  let(:space) { Space.create! name: 'co.up', subdomain: 'co-up' }
  let!(:admin) { space.admins.create! access_token: '123' }

  it 'adds a confirmed member' do
    stub_request(:post, %r{co-up.slack.com/api/users.admin.invite})
      .to_return(body: {ok: true}.to_json)
    stub_request(:get, 'https://co-up.cobot.me/api/memberships/456')
      .with(headers: {'Authorization' => 'Bearer 123'})
      .to_return(body: {name: 'joe doe', email: 'joe@doe.com'}.to_json)
    team = space.teams.create! name: 'team', slack_token: 'sl123', slack_url: 'http://co-up.slack.com'

    post space_team_membership_confirmation_url(space, team),
      url: 'https://co-up.cobot.me/api/memberships/456'
    expect(response.status).to eql(200)

    expect(a_request(:post, 'https://co-up.slack.com/api/users.admin.invite').with(
      body: hash_including(token: 'sl123', email: 'joe@doe.com',
        first_name: 'joe'))
    ).to have_been_made
  end

  it 'does not add members with no email' do
    stub_request(:get, 'https://co-up.cobot.me/api/memberships/456')
      .to_return(body: {email: ''}.to_json)

    team = space.teams.create! name: 'team', slack_token: 'sl123', slack_url: 'http://co-up.slack.com'

    post space_team_membership_confirmation_url(space, team),
      url: 'https://co-up.cobot.me/api/memberships/456'
    expect(response.status).to eql(200)

    expect(a_request(:post, 'https://co-up.slack.com/api/users.admin.invite'))
      .to_not have_been_made
  end

  it 'returns 410 if the team has been removed in the app' do
    post space_team_membership_confirmation_url(space, '521495cc-049b-4ed4-902b-a2d70c5518e5'),
      url: 'https://co-up.cobot.me/api/memberships/456'

    pending
    expect(response.status).to eql(410)
  end

  it 'returns 410 if the team has been removed on slack' do
    stub_request(:post, %r{co-up.slack.com/api/users.admin.invite})
      .to_return(status: 200, body: {ok: false, error: 'invalid_auth'}.to_json)
    stub_request(:get, 'https://co-up.cobot.me/api/memberships/456')
      .to_return(body: {email: 'joe@doe.com'}.to_json)
    team = space.teams.create! name: 'team', slack_token: 'sl123', slack_url: 'http://co-up.slack.com'

    post space_team_membership_confirmation_url(space, team),
      url: 'https://co-up.cobot.me/api/memberships/456'

    pending
    expect(response.status).to eql(410)
    expect { team.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it 'returns 200 even if the user could not be added to slack' do
    stub_request(:post, %r{co-up.slack.com/api/users.admin.invite})
      .to_return(status: 200, body: {ok: false, error: 'xyz'}.to_json)
    stub_request(:get, 'https://co-up.cobot.me/api/memberships/456')
      .to_return(body: {email: 'joe@doe.com'}.to_json)
    team = space.teams.create! name: 'team', slack_token: 'sl123', slack_url: 'http://co-up.slack.com'

    post space_team_membership_confirmation_url(space, team),
      url: 'https://co-up.cobot.me/api/memberships/456'

    expect(response.status).to eql(200)
    expect { team.reload }.to_not raise_error
  end

  it 'does nothing but returns 200 if the membership has been deleted' do
    stub_request(:get, 'https://co-up.cobot.me/api/memberships/456')
      .to_return(status: 404)

    team = space.teams.create! name: 'team', slack_token: 'sl123', slack_url: 'http://co-up.slack.com'

    post space_team_membership_confirmation_url(space, team),
      url: 'https://co-up.cobot.me/api/memberships/456'
    expect(response.status).to eql(200)

    expect(a_request(:post, 'https://co-up.slack.com/api/users.admin.invite'))
      .to_not have_been_made
  end
end
