OmniAuth.config.test_mode = true

RSpec.configure do |c|
  c.before(:each) do
    OmniAuth.config.mock_auth[:cobot] = OmniAuth::AuthHash.new(
      uid: 'cobot-user-1',
      credentials: {token: "12345"},
      info: {email: "janesmith@example.com"},
      extra: {
        raw_info: {
          memberships: [],
          admin_of:  []
        }
      }
    )
  end
end
