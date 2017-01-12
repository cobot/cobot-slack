RSpec.configure do |c|
  c.before(:example) do
    stub_request(:get, 'https://www.cobot.me/api/spaces/co-up')
      .to_return(body: {id: 'space-co-up'}.to_json)

    stub_request(:post, 'https://www.cobot.me/api/access_tokens/12345/space')
      .with(
        headers: {'Authorization' => 'Bearer 12345'},
        body: {space_id: 'space-co-up'})
      .to_return(body: {token: 'space-token-12345'}.to_json)
  end
end
