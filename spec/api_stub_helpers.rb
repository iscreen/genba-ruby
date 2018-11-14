
module ApiStubHelpers
  def self.token
    # "
    # {
    #   \"token\": \"ERGOJ5436ESGERBSIHDFS8HOW4IFO8HOW4FW44W===\",
    #   \"expiration\": \"#{(Time.now + 86400).strftime('%FT%T')}\"
    # }
    # "
    {
      token: 'ERGOJ5436ESGERBSIHDFS8HOW4IFO8HOW4FW44W===',
      expiration: "#{(Time.now + 86400).strftime('%FT%T')}"
    }.to_json
  end

  def self.products(sku_id = nil)
    json_raw = fixture_file('products.json')
    return json_raw unless sku_id
    payload = filter_by_key_value(JSON.parse(json_raw), 'skuId', sku_id)
    payload.to_json
  end

  def self.change_products
    json_raw = fixture_file('products.json')
    payload = JSON.parse(json_raw)
    payload.each_slice(2).to_a.first.to_json
  end

  def self.removed_products
    json_raw = fixture_file('products.json')
    payload = JSON.parse(json_raw)
    [payload[-1]].to_json
  end

  def self.restrictions(product_id = nil)
    json_raw = fixture_file('restrictions.json')
    return json_raw unless product_id
    payload = filter_by_key_value(JSON.parse(json_raw), 'productSKUId', product_id)
    payload.to_json
  end

  def self.prices
    json_raw = fixture_file('prices.json')
  end

  def self.keys
    json_raw = fixture_file('keys.json')
  end

  def self.single_key
    json_raw = fixture_file('single-key.json')
  end

  def self.test_keys
    json_raw = fixture_file('single-key.json')
  end

  def self.key_activated_status(sku_id)
    key_status(sku_id, 'Activated')
  end

  def self.key_allocated_status(sku_id)
    key_status(sku_id, 'Allocated')
  end

  def self.key_report_usage_reject
    {
      acceptedCount: 0,
      rejectedCount: 1,
      rejectedKeys: [
        {
          keyId: '00000000-ffff-2222-3333-444444444444',
          keyCode: '',
          Status: 'Key not found',
          product: '',
          sku: '',
          parentKeyId: nil,
          productSKUId: '00000000-0000-0000-0000-000000000000'
        }
      ]
    }.to_json
  end

  def self.key_report_usage_accept
    {
      acceptedCount: 1,
      rejectedCount: 0,
      rejectedKeys: []
    }.to_json
  end

  def self.key_black_list(key_id)
    [
      {
        keyCode: nil,
        keyId: key_id,
        status: 'Disabled',
        product: nil,
        sku: nil,
        parentKeyId: nil,
        productSKUId: "00000000-0000-0000-0000-000000000000"
      }
    ].to_json
  end

  def self.direct_entitlement_active_error(sku_id)
    {
      productSkuId: sku_id,
      detailedStatus: 9,
      importTransactionId: nil,
      status: 1,
      statusText: "Error-ThereisnoactiverelationshiporProduct/SKUisnotavailable",
      keys: [
      ]
    }.to_json
  end

  def self.direct_entitlement_active(sku_id)
    {
      productSkuId: sku_id,
      detailedStatus: 0,
      importTransactionId: nil,
      status: 0,
      statusText: "Error-ThereisnoactiverelationshiporProduct/SKUisnotavailable",
      keys: [
        {
          keyCode: '00000000-6EC3-4978-B5AE-1213C50CB366',
          keyId: "00000000-90ec-4b9a-9e4a-001103517351",
          status: "Allocated",
          product: "Genba Test Product",
          sku: "EFIS",
          parentKeyId: nil,
          productSKUId: "00000000-7d18-4cbc-ab44-162b7855d3ac"
        }
      ]
    }.to_json
  end

  def self.direct_entitlement_redeem(sku_id)
    {
      status: 0,
      detailedStatus: 0,
      statusText: '',
      importTransactionId: "00000000-0000-0000-0000-000000000000",
      productSkuId: "00000000-0000-0000-0000-000000000000",
      keys: [
        {
          keyId: "00000000-ffff-2222-3333-444444444444",
          status: "Allocated",
          product: "A cool game",
          sku: "EFIGS",
          parentKeyId: "",
          productSKUId: "00000000-ffff-2222-3333-444444444444"
        },
        {
          keyId: "00000000-ffff-2222-3333-444444444444",
          status: "Allocated",
          product: "A cool game",
          sku: "EFIGS",
          parentKeyId: "",
          productSKUId: "00000000-ffff-2222-3333-444444444444"
        }
      ]
    }.to_json
  end

  private

  def self.filter_by_key_value(collection, key, value)
    collection.each do |payload|
      return payload if payload[key] == value
    end
  end

  def self.fixture_file(filename)
    File.read(File.join(File.expand_path('../', __FILE__), "fixtures/#{filename}"))
  end

  def self.key_status(sku_id, status)
    {
      skuId: sku_id,
      product: 'Genba Test Product',
      sku: 'EFIS',
      statusDate: DateTime.now.strftime('%FT%T'),
      reservedDate: nil,
      status: status,
      statusText: nil
    }.to_json
  end
end
