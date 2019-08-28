# Genba Ruby

[![Build Status](https://travis-ci.org/iscreen/genba-ruby.svg)](https://travis-ci.org/iscreen/genba-ruby)
[![CircleCI](https://circleci.com/gh/iscreen/genba-ruby.svg?style=svg)](https://circleci.com/gh/iscreen/genba-ruby)
[![Gem Version](https://badge.fury.io/rb/genba-ruby.svg)](https://badge.fury.io/rb/genba-ruby)

The Genba Library provides convenient access to the [Genba API V3](https://api.genbadigital.io/doc) from applications written in the Ruby language.
  * [Genba Digital](https://genbadigital.com/)
  * [Genba API V2](https://api.genbagames.com/doc/)
  * [Genba API V3 Sandbox](https://sandbox.genbadigital.io/doc/)
  * [Genba API V3 Production](https://api.genbadigital.io/doc)

## Basic Usage

```ruby
require 'genba'

GENBA = Genba.client(
  resource: 'resource-0000-0000-0000-000000000000',
  account_id: 'account0-0000-0000-0000-000000000000',
  cert: 'your.domain.crt',
  key: 'your.domain.key',
  sandbox: true # default: false
)
```

## Test certificate/auth
  * Upload certificate from Genba Portal

```
GENBA.generate_token
```

## Ping
  * [Genba Ping API](https://sandbox.genbadigital.io/doc/#/Ping)
```
GENBA.ping.perform
```

## Products
  * [Genba Products API](https://sandbox.genbadigital.io/doc/#/Products)
  * spec/genba/client/products_spec.rb
```
# 'GET' do
  GENBA.products.list(include_meta: false)

# 'GET - skuId' do
  GENBA.products.get('710362cb-8022-45c1-babf-dae862311c14')

# 'Changes' do
  GENBA.products.list(from_date: DateTime.now - 2)

# 'Changes - with countryISO' do
  GENBA.products.list(from_date: DateTime.now - 2, country_code: 'US')

# 'Removed - with from_date' do
  GENBA.products.list(from_date: DateTime.now - 2, deleted: true)

# 'Removed - with country_iso' do
  GENBA.products.list(from_date: DateTime.now - 2, deleted: true, country_code: 'US')
```

**Example for fetch all pages data**
```
# Check/Use ContinuationToken to fetch next page

all_products = []
ms = Benchmark.ms do
  list = {}
  1.step do |index|
    list = GENBA.products.list(include_meta: true, continuation_token: list['ContinuationToken'])
    puts "page: #{index}, size: #{list['Products'].size}"
    all_products += list['Products']
    break if list['ContinuationToken'].nil?
  end

  all_products.size
end
```

## Prices
  * [Genba Prices API](https://sandbox.genbadigital.io/doc/#/Prices)
  * spec/genba/client/prices_spec.rb

## Promotions
  * [Genba Promotions API](https://sandbox.genbadigital.io/doc/#/Promotions)

## Reservations
  * [Genba Reservations API](https://sandbox.genbadigital.io/doc/#/Reservations)
  * spec/genba/client/reservations_spec.rb

## Orders
  * [Genba Orders API](https://sandbox.genbadigital.io/doc/#/Orders)
  * spec/genba/client/orders_spec.rb

## DirectEntitlement
  * [Genba DirectEntitlement API](https://sandbox.genbadigital.io/doc/#/DirectEntitlement)
  * spec/genba/client/direct_entitlements/activations_spec.rb
  * spec/genba/client/direct_entitlements/redemptions_spec.rb
