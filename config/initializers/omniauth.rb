require "omniauth/strategies/cobot"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cobot, Rails.application.secrets.cobot_client_id,
    Rails.application.secrets.cobot_client_secret,
      scope: 'read_user read_memberships write',
      client_options: {site: Rails.application.config.cobot_site,
        authorize_url: "#{Rails.application.config.cobot_site}/oauth/authorize",
        token_url: "#{Rails.application.config.cobot_site}/oauth/access_token"}
end
