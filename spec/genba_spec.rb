require 'spec_helper'

RSpec.describe Genba, '#client' do
  context 'asks for client' do
    it 'returns client' do
      client = Genba.client(
        username: 'api_genba_user',
        app_id: '00000000-0000-0000-0000-000000000000',
        api_key: '00000000000000000000000000000000',
        customer_account_id: '00000000000000000000000000000000'
      )
      expect(client).to be_a ::Genba::Client
    end
  end
end
