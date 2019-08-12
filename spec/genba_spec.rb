require 'spec_helper'

RSpec.describe Genba, '#client' do
  let!(:crt_path) { File.join(Dir.pwd, 'tmp/fake_cert.crt') }
  let!(:key_path) { File.join(Dir.pwd, 'tmp/fake_cert.key') }
  before :each do
    ApiStubHelpers.certification(crt_path, key_path)

    stub_request(:post, 'https://login.microsoftonline.com/aad.genbadigital.io/oauth2/token')
      .to_return(body: ApiStubHelpers.token)
  end

  context 'asks for client' do
    it 'returns client' do
      client = Genba.client(
        resource: 'resource-0000-0000-0000-000000000000',
        account_id: 'account-0000-0000-0000-000000000000',
        cert: crt_path,
        key: key_path
      )

      client.generate_token
      expect(client).to be_a ::Genba::Client
    end
  end

  context 'sandbox' do

    it 'sandbox' do
      client = Genba.client(
        resource: 'resource-0000-0000-0000-000000000000',
        account_id: 'account-0000-0000-0000-000000000000',
        cert: crt_path,
        key: key_path
      )

      expect(client.instance_variable_get(:@api_url)).to eq Genba::Client::SANDBOX_API_URL

      client = Genba.client(
        resource: 'resource-0000-0000-0000-000000000000',
        account_id: 'account-0000-0000-0000-000000000000',
        cert: crt_path,
        key: key_path,
        sandbox: true
      )

      expect(client.instance_variable_get(:@api_url)).to eq Genba::Client::SANDBOX_API_URL
    end

    it 'production' do
      client = Genba.client(
        resource: 'resource-0000-0000-0000-000000000000',
        account_id: 'account-0000-0000-0000-000000000000',
        cert: crt_path,
        key: key_path,
        sandbox: false
      )

      expect(client.instance_variable_get(:@api_url)).to eq Genba::Client::PRODUCTION_API_URL
    end
  end
end
