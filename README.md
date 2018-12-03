# Genba Ruby

[![Build Status](https://travis-ci.org/iscreen/genba-ruby.svg)](https://travis-ci.org/iscreen/genba-ruby)
[![CircleCI](https://circleci.com/gh/iscreen/genba-ruby.svg?style=shield)](https://circleci.com/gh/iscreen/genba-ruby)
[![Gem Version](https://badge.fury.io/rb/genba-ruby.svg)](https://badge.fury.io/rb/genba-ruby)

The Genba Library provides convenient access to the [Genba API](https://api.genbagames.com/doc/) from applications written in the Ruby language.

## Basic Usage

```ruby
    require 'genba'

    genba_client = Genba.client(
      username: 'api_genba_user',
      app_id: '00000000-0000-0000-0000-000000000000',
      api_key: '00000000000000000000000000000000',
      customer_account_id: '00000000-0000-0000-0000-000000000000'
    )
```

## Products
[Genba Products API](https://api.genbagames.com/doc/#api-Product)

### Product - Changes

Return a list of products which have changed since a given date, including basic or advanced metadata.

```ruby
payload = {
  from_date: DateTime.now - 1,
  country_iso: 'US',
  include_meta: false
}

response = genba_client.products.get_changes(payload)
```

```ruby
payload = {
  include_meta: false
}

response = genba_client.products.get_changes(payload)
```

### Product - Get

Return a list of product objects, including basic or advanced metadata.

```ruby
payload = {
  include_meta: false
}

response = genba_client.products.get_products(payload)
```

Return a list of product objects with countryISO

```ruby
payload = {
  country_iso: 'US',
  include_meta: false
}

response = genba_client.products.get_products(payload)
```

Retrieve an existing product

```ruby
payload = {
  sku_id: '79cf9bb2-e7f5-448f-b996-c52e4b2bb351',
  include_meta: true
}

product = genba_client.products.get_products(payload)
```

### Product - Removed

Return a list of products which have been removed since a given date.

```ruby
payload = {
  from_date: DateTime.now - 1,
  country_iso: 'US',
  include_meta: false
}

response = genba_client.products.get_removed(payload)
```

## Prices
[Genba Prices API](https://api.genbagames.com/doc/#api-Prices)

Get latest prices for all of your available products. It is recommended that you call this daily to get accurate pricing.

```ruby
response = genba_client.prices.get_prices
```

## Restrictions
[Genba Restrictions API](https://api.genbagames.com/doc/#api-Restrictions)

### Restrictions - Get

Returns a list of product sku restrictions, whitelist - can only sold in countries, blacklist - cannot be sold in countries.

Returns a list of product sku restrictions by countryISO

```ruby
payload = {
  country_iso: 'US'
}

response = genba_client.restrictions.get_restrictions(payload)
response[:productRestriction]
```

Returns a list of product sku restrictions by countryISO, productID and fromDate

```ruby
payload = {
  product_id: '84d90a06-f458-4ed8-8f3d-91aa84cc6577',
  from_date: 1.days.ago.strftime('%FT%T'),
  country_iso: 'US'
}

response = genba_client.restrictions.get_restrictions(payload)
response[:productRestriction]
```

## Keys
[Genba Keys API](https://api.genbagames.com/doc/#api-Keys)

### Keys - Get Test Keys

Request Product Test Keys for a SKU

```ruby
response = genba_client.keys.get_test_keys('84d90a06-f458-4ed8-8f3d-91aa84cc6577')

response[:status]
response[:keys]
```

Request Product Keys for a SKU

```ruby

response = genba_client.keys.get_keys('84d90a06-f458-4ed8-8f3d-91aa84cc6577', 1, customerAccountId)

response[:status]
response[:keys]
```

### Keys - Report Usage

Report usage with keyCode

```ruby
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

response = genba_client.keys.get_report_usage([key])

response[:acceptedCount]
response[:rejectedCount]
```

Report usage with key
```ruby
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
response = genba_client.keys.get_report_usage([key])

response[:acceptedCount]
response[:rejectedCount]
```

## DirectEntitlement

### DirectEntitlement - Activate

Use this method to get and activate keys for a Direct Entitlement SKU. You will be charged at the point of calling this method.

```ruby
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
}
key_res = @client.direct_entitlements.activate(payload)
```

### DirectEntitlement - Redeem

Use this method to redeem keys already sold for a Direct Entitlement SKU and link them to the end-user's account. You will not be charged at the point of calling this method.

```ruby
payload = {
  sku_id: 'd972e0c7-5ddb-4e0d-9138-a78a6b269e99',
  key_id: '00000000-0000-0000-0000-000000000000',
  end_user_id: '00001',
  end_user_ticket: 'ticket00001'
}
key_res = @client.direct_entitlements.redeem(payload)
```
