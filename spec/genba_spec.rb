require 'spec_helper'

RSpec.describe Genba, '#client' do
  context 'asks for client' do
    it 'returns client' do
      client = Genba.client
      expect(client).to be_a ::Genba::Client
    end
  end
end
