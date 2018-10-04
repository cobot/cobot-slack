require 'rails_helper'

RSpec.describe TeamService, '#invite' do
  let(:space) { instance_double(Space, subdomain: 'co-up') }
  let(:team) { instance_double(Team, space_id: 'space-1', slack_url: '', space: space).as_null_object }

  it 'create an activity on success' do
    allow_any_instance_of(Slack::Client)
      .to receive(:admin_invite) { {ok: true} }

    expect(ActivityWorker)
      .to receive(:perform_async)
      .with('space-1', 'Invited joe (joe@doe.com) to join Slack.')

    TeamService.new(team).invite('joe@doe.com', 'joe', 'member_1')
  end

  it 'create an activity on error' do
    allow_any_instance_of(Slack::Client)
      .to receive(:admin_invite) { {ok: false, error: 'already_invited'} }

    expect(ActivityWorker)
      .to receive(:perform_async)
      .with('space-1', 'Error inviting joe (joe@doe.com) to join Slack: already invited.', 'WARN')

    TeamService.new(team).invite('joe@doe.com', 'joe', 'member_1')
  end
end
