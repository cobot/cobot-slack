RSpec.configure do |c|
  c.before(:example) do
    stub_request(:post, 'https://www.cobot.me/apiaccess_token/12345/space')
      .with(headers: {'Authorization' => 'Bearer 12345'})
      .to_return(body: {token: 'space-token-12345'}.to_json)
  end
end
