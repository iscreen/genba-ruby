# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Genba::Client::Ping do
  it '#perform' do
    stub_request(:get, /api\/v3-0\/ping/)
      .to_return(body: ApiStubHelpers.ping)
    ping = @client.ping.perform

    expect(ping.key?('EtailerName')).to be_truthy
    expect(ping.key?('CustomerAccountNumber')).to be_truthy
    expect(ping.key?('TokenValidFrom')).to be_truthy
    expect(ping.key?('TokenValidTo')).to be_truthy
  end
end
