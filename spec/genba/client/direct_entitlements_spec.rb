# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Genba::Client::DirectEntitlements do
  let(:sku_id) { '98b9d3d8-dac2-4454-96cd-0011607500f0' }

  it '#activate' do
    stub_request(:get, /https:\/\/api.genbagames.com\/api\/directentitlement\/activate\?ETailerBuyingPrice=/)
      .to_return(body: ApiStubHelpers.direct_entitlement_active(sku_id))

    payload = {
      sku_id: 'd972e0c7-5ddb-4e0d-9138-a78a6b269e99',
      country_iso: 'US',
      end_user_ip_address: '182.212.212.22',
      sale_date: DateTime.now,
      end_user_id: '0000001',
      end_user_ticket: 'ticket0000001',
      e_tailer_buying_price: 18.29,
      e_tailer_buying_price_currency_code: 'USD',
      e_tailer_selling_price_net: 19.89,
      e_tailer_selling_price_gross: 20.29,
      e_tailer_selling_price_currency_code: 'USD'
    }

    key_res = @client.direct_entitlements.activate(payload)
    expect(key_res['status']).to eq(0)
    expect(key_res['detailedStatus']).to eq(0)
    expect(key_res.key?('keys')).to be_truthy
    game_key = key_res['keys'].first
    expect(game_key.key?('keyId')).to be_truthy
    expect(game_key.key?('status')).to be_truthy
    expect(game_key.key?('product')).to be_truthy
    expect(game_key.key?('sku')).to be_truthy
    expect(game_key.key?('parentKeyId')).to be_truthy
    expect(game_key.key?('productSKUId')).to be_truthy
  end

  it '#activate with e_tailer_subsidiary' do
    stub_request(:get, /https:\/\/api.genbagames.com\/api\/directentitlement\/activate\?ETailerBuyingPrice=/)
      .to_return(body: ApiStubHelpers.direct_entitlement_active(sku_id))

    payload = {
      sku_id: 'd972e0c7-5ddb-4e0d-9138-a78a6b269e99',
      country_iso: 'US',
      end_user_ip_address: '182.212.212.22',
      sale_date: DateTime.now,
      end_user_id: '0000001',
      end_user_ticket: 'ticket0000001',
      e_tailer_buying_price: 18.29,
      e_tailer_buying_price_currency_code: 'USD',
      e_tailer_selling_price_net: 19.89,
      e_tailer_selling_price_gross: 20.29,
      e_tailer_selling_price_currency_code: 'USD',
      e_tailer_subsidiary: 'Walmart'
    }

    key_res = @client.direct_entitlements.activate(payload)
    expect(key_res['status']).to eq(0)
  end

  it '#activate - error' do
    stub_request(:get, /https:\/\/api.genbagames.com\/api\/directentitlement\/activate\?ETailerBuyingPrice=/)
      .to_return(body: ApiStubHelpers.direct_entitlement_active_error(sku_id))
    payload = {
      sku_id: 'd972e0c7-5ddb-4e0d-9138-a78a6b269e99',
      country_iso: 'US',
      end_user_ip_address: '182.212.212.22',
      sale_date: DateTime.now,
      end_user_id: '0000001',
      end_user_ticket: 'ticket0000001',
      e_tailer_buying_price: 18.29,
      e_tailer_buying_price_currency_code: 'USD',
      e_tailer_selling_price_net: 19.89,
      e_tailer_selling_price_gross: 20.29,
      e_tailer_selling_price_currency_code: 'USD'
    }
    key_res = @client.direct_entitlements.activate(payload)
    expect(key_res['status']).not_to eq(0)
    expect(key_res['detailedStatus']).not_to eq(0)
  end

  it '#reedem' do
    stub_request(:get, /https:\/\/api.genbagames.com\/api\/directentitlement\/redeem\?customerAccountId=.*&keyId=.*&skuId=/)
      .to_return(body: ApiStubHelpers.direct_entitlement_redeem(sku_id))

    payload = {
      sku_id: 'd972e0c7-5ddb-4e0d-9138-a78a6b269e99',
      key_id: '00000000-0000-0000-0000-000000000000',
      end_user_id: '00001',
      end_user_ticket: 'ticket00001'
    }
    key_res = @client.direct_entitlements.redeem(payload)
    expect(key_res['status']).to eq(0)
    expect(key_res['detailedStatus']).to eq(0)
    expect(key_res.key?('keys')).to be_truthy
    game_key = key_res['keys'].first
    expect(game_key.key?('keyId')).to be_truthy
    expect(game_key.key?('status')).to be_truthy
    expect(game_key.key?('product')).to be_truthy
    expect(game_key.key?('sku')).to be_truthy
    expect(game_key.key?('parentKeyId')).to be_truthy
    expect(game_key.key?('productSKUId')).to be_truthy
  end
end
