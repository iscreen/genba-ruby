# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Genba::Client::Products do
  context 'Product' do
    it 'GET' do
      stub_request(:get, /api.genbagames.com\/api\/product\?includeMeta=/)
        .to_return(body: ApiStubHelpers.products)
      products = @client.products.get_products
      product = products.first
      expect(product.key?('skuId')).to be_truthy
      expect(product.key?('name')).to be_truthy
      expect(product.key?('platform')).to be_truthy
      expect(product.key?('sku')).to be_truthy
      expect(product.key?('protectionSystem')).to be_truthy
    end

    it 'GET - skuId' do
      stub_request(:get, /api.genbagames.com\/api\/product\?includeMeta=.*&skuId=/)
        .to_return(body: ApiStubHelpers.products('710362cb-8022-45c1-babf-dae862311c14'))
      products = @client.products.get_products(sku_id: '710362cb-8022-45c1-babf-dae862311c14')
      product = products.first
      expect(product.key?('skuId')).to be_truthy
      expect(product.key?('name')).to be_truthy
      expect(product.key?('platform')).to be_truthy
      expect(product.key?('sku')).to be_truthy
      expect(product.key?('protectionSystem')).to be_truthy
    end

    it 'Changes' do
      stub_request(:get, /api.genbagames.com\/api\/product\/changes\?fromDate=/)
        .to_return(body: ApiStubHelpers.change_products)
      products = @client.products.get_changes(from_date: DateTime.now - 2)
      product = products.first
      expect(product.key?('skuId')).to be_truthy
      expect(product.key?('name')).to be_truthy
      expect(product.key?('platform')).to be_truthy
      expect(product.key?('sku')).to be_truthy
      expect(product.key?('protectionSystem')).to be_truthy
    end

    it 'Changes - with countryISO' do
      stub_request(:get, /api.genbagames.com\/api\/product\/changes\?fromDate=/)
        .to_return(body: ApiStubHelpers.change_products)
      products = @client.products.get_changes(from_date: DateTime.now - 2)
      product = products.first
      expect(product.key?('skuId')).to be_truthy
      expect(product.key?('name')).to be_truthy
      expect(product.key?('platform')).to be_truthy
      expect(product.key?('sku')).to be_truthy
      expect(product.key?('protectionSystem')).to be_truthy
    end

    it 'Removed' do
      stub_request(:get, /api.genbagames.com\/api\/product\/removed/)
        .to_return(body: ApiStubHelpers.removed_products)
      products = @client.products.get_removed
      product = products.first
      expect(product.key?('skuId')).to be_truthy
      expect(product.key?('name')).to be_truthy
      expect(product.key?('platform')).to be_truthy
      expect(product.key?('sku')).to be_truthy
      expect(product.key?('protectionSystem')).to be_truthy
    end

    it 'Removed - with from_date' do
      stub_request(:get, /api.genbagames.com\/api\/product\/removed\?customerAccountId=.*&fromDate=/)
        .to_return(body: ApiStubHelpers.removed_products)
      products = @client.products.get_removed(from_date: DateTime.now - 2)
      product = products.first
      expect(product.key?('skuId')).to be_truthy
      expect(product.key?('name')).to be_truthy
      expect(product.key?('platform')).to be_truthy
      expect(product.key?('sku')).to be_truthy
      expect(product.key?('protectionSystem')).to be_truthy
    end

    it 'Removed - with country_iso' do
      stub_request(:get, /api.genbagames.com\/api\/product\/removed\?countryISO=.*&customerAccountId=.*&fromDate=/)
        .to_return(body: ApiStubHelpers.removed_products)
      products = @client.products.get_removed(from_date: DateTime.now - 2, country_iso: 'EU')
      product = products.first
      expect(product.key?('skuId')).to be_truthy
      expect(product.key?('name')).to be_truthy
      expect(product.key?('platform')).to be_truthy
      expect(product.key?('sku')).to be_truthy
      expect(product.key?('protectionSystem')).to be_truthy
    end
  end
end
