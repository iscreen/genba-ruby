# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Genba::Client::Reservations do
  let(:sku_id) { '98b9d3d8-dac2-4454-96cd-0011607500f0' }

  it '#reservations-perform' do
    stub_request(:post, /api\/v3-0\/reservations/)
      .to_return(body: ApiStubHelpers.single_key)

    payload = {
      ClientTransactionID: 'trx_id',
      Properties: {
        Sku: 'SANDBOX_SKU_ID',
        BuyingPrice: {
            Amount: 9.6,
            CurrencyCode: 'CIS'
        },
        SellingPrice: {
            NetAmount: 18.0,
            GrossAmount: 18.0,
            CurrencyCode: 'CIS'
        },
        ConsumerIP: '8.8.8.8',
        CountryCode: 'TW'
      }
    }

    key_res = @client.reservations.perform(payload)
    # expect(key_res['status']).to eq(0)
    # expect(key_res.key?('statusText')).to be_truthy
    # expect(key_res.key?('currencyId')).to be_truthy
    # expect(key_res.key?('keys')).to be_truthy
    # game_key = key_res['keys'].first
    # expect(game_key.key?('keyId')).to be_truthy
    # expect(game_key.key?('keyCode')).to be_truthy
    # expect(game_key.key?('status')).to be_truthy
    # expect(game_key.key?('product')).to be_truthy
    # expect(game_key.key?('sku')).to be_truthy
    # expect(game_key.key?('parentKeyId')).to be_truthy
    # expect(game_key.key?('productSKUId')).to be_truthy
    # expect(['Available', 'Allocated', 'Activated', 'Disabled'].include?(game_key['status'])).to be_truthy
  end

  it '#reservations-get' do
    stub_request(:get, /api\/v3-0\/reservations\/.+/)
      .to_return(body: ApiStubHelpers.single_key)

    key_res = @client.reservations.get('reservation_id')
  end
end
