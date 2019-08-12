# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Genba::Client::Orders do
  let(:sku_id) { '98b9d3d8-dac2-4454-96cd-0011607500f0' }

  it '#perform' do
    stub_request(:post, /api\/v3-0\/orders/)
      .to_return(body: '{}')

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

    key_res = @client.orders.perform(payload)
  end

  it '#perform - with reservation' do
    payload = {
      ClientTransactionID: 'ClientTransactionID',
      ReservationID: 'ReservationID'
    }

    stub_request(:post, /api\/v3-0\/orders/)
      .to_return(body: '{}')

    key_res = @client.orders.perform(payload)
  end

  it '#get' do
    stub_request(:get, /api\/v3-0\/orders\/.+/)
      .to_return(body: '{}')

    key_res = @client.orders.get('order_id')
  end

  it '#perform_action' do
    payload = {
      Action: 'Action',
      Reason: 'Reason'
    }

    stub_request(:post, /api\/v3-0\/orders\/.+/)
      .to_return(body: '{}')

    key_res = @client.orders.perform_action('order_id', payload)
  end

  it '#get_by_ctid' do
    stub_request(:get, /api\/v3-0\/orders\/ctid\/.+/)
      .to_return(body: '{}')

    key_res = @client.orders.get_by_ctid('ctid')
  end
end
