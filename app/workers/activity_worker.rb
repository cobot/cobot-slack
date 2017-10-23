class ActivityWorker
  include Sidekiq::Worker

  def perform(space_id, text)
    space = Space.where(id: space_id).first || return
    api_client = CobotClient::ApiClient.new(space.access_token)
    api_client.post space.subdomain, '/activities', text: text
  end
end
