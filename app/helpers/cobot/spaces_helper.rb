module Cobot
  module SpacesHelper
    include CobotClient::UrlHelper

    def space_logo_url(subdomain)
      cobot_url('www', "/api/spaces/#{subdomain}/logo")
    end
  end
end
