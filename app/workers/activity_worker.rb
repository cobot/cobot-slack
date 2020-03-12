# frozen_string_literal: true

class ActivityWorker
  include Sidekiq::Worker

  def perform(space_id, text, level = nil)
    space = Space.where(id: space_id).first || return
    api_client = CobotClient::ApiClient.new(space.access_token)
    api_client.post space.subdomain, '/activities', { text: text, level: level }.compact
  rescue CobotClient::Forbidden
    # unable to post actibity. admin does not have access to write activities.
  end
end
