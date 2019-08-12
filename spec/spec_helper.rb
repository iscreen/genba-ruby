require 'bundler/setup'
require 'rspec'
require 'webmock/rspec'
require 'byebug'
require 'genba'
require 'api_stub_helpers'
require 'uuidtools'
require 'active_support/all'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    crt_path = File.join(Dir.pwd, 'tmp/fake_cert.crt')
    key_path = File.join(Dir.pwd, 'tmp/fake_cert.key')
    ApiStubHelpers.certification(crt_path, key_path)

    @client = Genba.client(
      resource: 'resource-0000-0000-0000-000000000000',
      account_id: 'account-0000-0000-0000-000000000000',
      cert: crt_path,
      key: key_path
    )
    stub_request(:post, 'https://login.microsoftonline.com/aad.genbadigital.io/oauth2/token')
      .to_return(body: ApiStubHelpers.token)
  end
end
