module LoginHelpers
  def log_in(name = 'co.up', access_token: '12345')
    subdomain = name.gsub(/\W+/, '-')
    OmniAuth.config.mock_auth[:cobot]["extra"]["raw_info"]["admin_of"] = [
      {'space_subdomain' => subdomain, 'name' => 'Joe', 'space_name' => name}
    ]
    OmniAuth.config.mock_auth[:cobot]['credentials']['token'] = access_token
    visit root_path
    click_on 'Get Started'
    click_on 'Log in'
    Space.where(subdomain: subdomain).first
  end
end

RSpec.configure do |c|
  c.include LoginHelpers
end
