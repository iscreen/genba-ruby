# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Genba::Client::Prices do
  it '#list' do
    stub_request(:get, /api\/v3-0\/prices/)
      .to_return(body: ApiStubHelpers.prices)
    prices = @client.prices.list
    expect(prices.length).to be > 0

    price = prices.first
    expect(price.key?('skuId')).to be_truthy
    expect(price.key?('product')).to be_truthy
    expect(price.key?('currencyId')).to be_truthy
    expect(price.key?('currencyName')).to be_truthy
    expect(price.key?('currencyCode')).to be_truthy
    expect(price.key?('wsp')).to be_truthy
    expect(price.key?('srp')).to be_truthy
    expect(price.key?('isFlashPrice')).to be_truthy
  end
end
