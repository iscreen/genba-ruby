# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Genba::Client::Keys do
  let(:sku_id) { '98b9d3d8-dac2-4454-96cd-0011607500f0' }

  it '#get_test_keys' do
    stub_request(:get, /https:\/\/api.genbagames.com\/api\/testKeys\?skuId=/)
      .to_return(body: ApiStubHelpers.test_keys)

    key_res = @client.keys.get_test_keys('d972e0c7-5ddb-4e0d-9138-a78a6b269e99')
    expect(key_res['status']).to eq(0)
    expect(key_res['statusText']).to eq('Keys available in response.')
    expect(key_res.key?('keys')).to eq(true)
    expect(key_res['keys'].first.key?('keyId')).to eq(true)
  end

  it '#get_keys' do
    stub_request(:get, /https:\/\/api.genbagames.com\/api\/keys\?customerAccountId=.*&quantity=.+&skuId=.*/)
      .to_return(body: ApiStubHelpers.single_key)

    key_res = @client.keys.get_keys(sku_id)
    expect(key_res['status']).to eq(0)
    expect(key_res.key?('statusText')).to be_truthy
    expect(key_res.key?('currencyId')).to be_truthy
    expect(key_res.key?('keys')).to be_truthy
    game_key = key_res['keys'].first
    expect(game_key.key?('keyId')).to be_truthy
    expect(game_key.key?('keyCode')).to be_truthy
    expect(game_key.key?('status')).to be_truthy
    expect(game_key.key?('product')).to be_truthy
    expect(game_key.key?('sku')).to be_truthy
    expect(game_key.key?('parentKeyId')).to be_truthy
    expect(game_key.key?('productSKUId')).to be_truthy
    expect(['Available', 'Allocated', 'Activated', 'Disabled'].include?(game_key['status'])).to be_truthy
  end

  it '#get_keys - quantity' do
    stub_request(:get, /https:\/\/api.genbagames.com\/api\/keys\?customerAccountId=.*&quantity=.+&skuId=.*/)
      .to_return(body: ApiStubHelpers.keys)

    key_res = @client.keys.get_keys(sku_id, 3)
    expect(key_res['status']).to eq(0)
    expect(key_res.key?('statusText')).to be_truthy
    expect(key_res.key?('currencyId')).to be_truthy
    expect(key_res.key?('keys')).to be_truthy
    expect(key_res['keys'].length).to be > 2
    game_key = key_res['keys'].first
    expect(game_key.key?('keyId')).to be_truthy
    expect(game_key.key?('keyCode')).to be_truthy
    expect(game_key.key?('status')).to be_truthy
    expect(game_key.key?('product')).to be_truthy
    expect(game_key.key?('sku')).to be_truthy
    expect(game_key.key?('parentKeyId')).to be_truthy
    expect(game_key.key?('productSKUId')).to be_truthy
    expect(['Available', 'Allocated', 'Activated', 'Disabled'].include?(game_key['status'])).to be_truthy
  end

  it '#get_key_status' do
    stub_request(:get, /https:\/\/api.genbagames.com\/api\/keys\/.*/)
      .to_return(body: ApiStubHelpers.key_allocated_status(sku_id))

    key_res = @client.keys.get_key_status(sku_id)
    expect(key_res.key?('status')).to be_truthy
    expect(key_res['status']).to eq('Allocated')
    expect(key_res.key?('skuId')).to be_truthy
    expect(key_res.key?('product')).to be_truthy
  end

  it '#get_key_code_status' do
    stub_request(:get, /https:\/\/api.genbagames.com\/api\/keys\?keyCode=.*/)
      .to_return(body: ApiStubHelpers.key_allocated_status(sku_id))

    key_res = @client.keys.get_key_code_status('3D56C692-0F4C-42AC-9996-A84DA3DC0EE9')
    expect(key_res.key?('status')).to be_truthy
    expect(key_res['status']).to eq('Allocated')
    expect(key_res.key?('skuId')).to be_truthy
    expect(key_res.key?('product')).to be_truthy
  end

  describe 'Report Usage' do
    it '#get_report_usage - accepted' do
      stub_request(:post, 'https://api.genbagames.com/api/keyReport')
        .to_return(body: ApiStubHelpers.key_report_usage_accept)

      key = KeyReportRequest.new(
        key: '00000000000000000000000000000000',
        country_iso: 'US',
        sale_date: DateTime.now,
        user_ip_address: '182.212.212.22',
        e_tailer_buying_price: 3.8,
        e_tailer_buying_price_currency_code: 'USD',
        e_tailer_selling_price_net: 3.2,
        e_tailer_selling_price_gross: 3.8,
        e_tailer_selling_price_currency_code: 'USD'
      )
      key_res = @client.keys.get_report_usage([key])

      expect(key_res.key?('acceptedCount')).to be_truthy
      expect(key_res.key?('rejectedCount')).to be_truthy
      expect(key_res.key?('rejectedKeys')).to be_truthy
      expect(key_res['acceptedCount']).to eq(1)
    end

    it '#get_report_usage - rejected' do
      stub_request(:post, 'https://api.genbagames.com/api/keyReport')
        .to_return(body: ApiStubHelpers.key_report_usage_reject)

      key = KeyReportRequest.new(
        key_id: '00000000-ffff-2222-3333-444444444444',
        country_iso: 'US',
        sale_date: DateTime.now,
        user_ip_address: '182.212.212.22',
        e_tailer_buying_price: 3.8,
        e_tailer_buying_price_currency_code: 'USD',
        e_tailer_selling_price_net: 3.2,
        e_tailer_selling_price_gross: 3.8,
        e_tailer_selling_price_currency_code: 'USD'
      )
      key_res = @client.keys.get_report_usage([key])

      expect(key_res.key?('acceptedCount')).to be_truthy
      expect(key_res.key?('rejectedCount')).to be_truthy
      expect(key_res.key?('rejectedKeys')).to be_truthy
      expect(key_res['rejectedCount']).to eq(1)
      expect(key_res['rejectedKeys'].length).to be > 0
      rejected_key = key_res['rejectedKeys'].first
      expect(rejected_key.key?('keyId')).to be_truthy
      expect(rejected_key.key?('keyCode')).to be_truthy
      expect(rejected_key.key?('Status')).to be_truthy
      expect(rejected_key.key?('product')).to be_truthy
      expect(rejected_key.key?('sku')).to be_truthy
      expect(rejected_key.key?('parentKeyId')).to be_truthy
      expect(rejected_key.key?('productSKUId')).to be_truthy
    end
  end
end
