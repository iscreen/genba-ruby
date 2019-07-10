# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Genba::Client::Products do
  context 'Product' do
    it 'GET' do
      stub_request(:get, /api\/v3-0\/products\?includeMeta\=.*/)
        .to_return(body: ApiStubHelpers.products)
      products = @client.products.list(include_meta: false)
      product = products.first
      expect(product.key?('skuId')).to be_truthy
      expect(product.key?('name')).to be_truthy
      expect(product.key?('platform')).to be_truthy
      expect(product.key?('sku')).to be_truthy
      expect(product.key?('protectionSystem')).to be_truthy
    end

    it 'GET - skuId' do
      stub_request(:get, /api\/v3-0\/products\/.+/)
        .to_return(body: ApiStubHelpers.products('710362cb-8022-45c1-babf-dae862311c14'))
      products = @client.products.get('710362cb-8022-45c1-babf-dae862311c14')
      product = products.first
      expect(product.key?('skuId')).to be_truthy
      expect(product.key?('name')).to be_truthy
      expect(product.key?('platform')).to be_truthy
      expect(product.key?('sku')).to be_truthy
      expect(product.key?('protectionSystem')).to be_truthy
    end

    it 'Changes' do
      stub_request(:get, /api\/v3-0\/products\?fromDate\=.+/)
        .to_return(body: ApiStubHelpers.change_products)
      products = @client.products.list(from_date: DateTime.now - 2)
      product = products.first
      expect(product.key?('skuId')).to be_truthy
      expect(product.key?('name')).to be_truthy
      expect(product.key?('platform')).to be_truthy
      expect(product.key?('sku')).to be_truthy
      expect(product.key?('protectionSystem')).to be_truthy
    end

    it 'Changes - with countryISO' do
      stub_request(:get, /api\/v3-0\/products\?countryCode=.+&fromDate\=.+/)
        .to_return(body: ApiStubHelpers.change_products)
      products = @client.products.list(from_date: DateTime.now - 2, country_code: 'US')
      product = products.first
      expect(product.key?('skuId')).to be_truthy
      expect(product.key?('name')).to be_truthy
      expect(product.key?('platform')).to be_truthy
      expect(product.key?('sku')).to be_truthy
      expect(product.key?('protectionSystem')).to be_truthy
    end

    it 'Removed - with from_date' do
      stub_request(:get, /api\/v3-0\/products\?deleted=.+&fromDate\=.+/)
        .to_return(body: ApiStubHelpers.removed_products)
      products = @client.products.list(from_date: DateTime.now - 2, deleted: true)
      product = products.first
      expect(product.key?('skuId')).to be_truthy
      expect(product.key?('name')).to be_truthy
      expect(product.key?('platform')).to be_truthy
      expect(product.key?('sku')).to be_truthy
      expect(product.key?('protectionSystem')).to be_truthy
    end

    it 'Removed - with country_iso' do
      stub_request(:get, /api\/v3-0\/products\?countryCode=.+&deleted=.+&fromDate\=.+/)
        .to_return(body: ApiStubHelpers.removed_products)
      products = @client.products.list(from_date: DateTime.now - 2, deleted: true, country_code: 'US')
      product = products.first
      expect(product.key?('skuId')).to be_truthy
      expect(product.key?('name')).to be_truthy
      expect(product.key?('platform')).to be_truthy
      expect(product.key?('sku')).to be_truthy
      expect(product.key?('protectionSystem')).to be_truthy
    end
  end
end
