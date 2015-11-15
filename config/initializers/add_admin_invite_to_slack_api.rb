module Slack
  module Endpoint
    module Admin
      def admin_invite(options)
        post('users.admin.invite', options)
      end
    end
  end
end

Slack::Client.class_eval do
  include Slack::Endpoint::Admin
end
