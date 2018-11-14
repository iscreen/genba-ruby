require 'bundler/setup'
require 'rspec'
require 'webmock/rspec'
require 'byebug'
require 'genba'
require 'api_stub_helpers'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    @client = Genba.client(
      username: 'api_genba_user',
      app_id: '00000000-0000-0000-0000-000000000000',
      api_key: '00000000000000000000000000000000'
    )

    stub_request(:post, 'https://api.genbagames.com/api/token')
      .to_return(body: ApiStubHelpers.token)
  end
end
