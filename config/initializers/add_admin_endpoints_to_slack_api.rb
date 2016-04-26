module Slack
  module Endpoint
    module Admin
      def admin_invite(email:, first_name:)
        post('users.admin.invite', email: email, first_name: first_name)
      end

      def admin_set_inactive(user:)
        post('users.admin.setInactive', user: user)
      end
    end
  end
end

Slack::Client.class_eval do
  include Slack::Endpoint::Admin
end
