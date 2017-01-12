require 'rails_helper'

describe 'adding members to slack', type: :request do
  let(:space) { Space.create! name: 'co.up', subdomain: 'co-up', access_token: '123' }
  let(:team) { space.teams.create! name: 'team', slack_token: 'sl123', slack_url: 'http://co-up.slack.com' }

  before(:each) do
  end

  it 'removes a canceled member' do
    stub_request(:post, 'https://co-up.slack.com/api/users.admin.setInactive')
      .to_return(body: {ok: true}.to_json)
    stub_request(:get, 'https://co-up.cobot.me/api/memberships/456')
      .with(headers: {'Authorization' => 'Bearer 123'})
      .to_return(body: {name: 'joe doe', email: 'joe@doe.com', canceled_to: '2015/01/01'}.to_json)
    slack_user = {id: 'U123', profile: {email: 'joe@doe.com', real_name: 'joe doe'}}
    stub_request(:post, 'https://co-up.slack.com/api/users.list')
      .with(body: {token: 'sl123'})
      .to_return(body: {members: [{profile: {email: 'x@y'}}, slack_user]}.to_json)

    post space_team_membership_cancelation_url(space, team),
      url: 'https://co-up.cobot.me/api/memberships/456'
    expect(response.status).to eql(200)

    expect(a_request(:post, 'https://co-up.slack.com/api/users.admin.setInactive')
      .with(body: hash_including(token: 'sl123', user: 'U123'))).to have_been_made
  end

  it 'invites members where the cancelation was undone' do
    stub_request(:post, 'https://co-up.slack.com/api/users.admin.invite')
      .to_return(body: {ok: true}.to_json)
    stub_request(:get, 'https://co-up.cobot.me/api/memberships/456')
      .with(headers: {'Authorization' => 'Bearer 123'})
      .to_return(body: {name: 'joe doe', email: 'joe@doe.com', canceled_to: nil}.to_json)

    post space_team_membership_cancelation_url(space, team),
      url: 'https://co-up.cobot.me/api/memberships/456'
    expect(response.status).to eql(200)

    expect(a_request(:post, 'https://co-up.slack.com/api/users.admin.invite')
      .with(body: hash_including(token: 'sl123', email: 'joe@doe.com',
        first_name: 'joe'))).to have_been_made
  end
end
