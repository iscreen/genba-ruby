# Genba Ruby

[![Build Status](https://travis-ci.org/iscreen/genba-ruby.svg)](https://travis-ci.org/iscreen/genba-ruby)
[![CircleCI](https://circleci.com/gh/iscreen/genba-ruby.svg?style=shield)](https://circleci.com/gh/iscreen/genba-ruby)
[![Gem Version](https://badge.fury.io/rb/genba-ruby.svg)](https://badge.fury.io/rb/genba-ruby)

The Genba Library provides convenient access to the [Genba API](https://api.genbagames.com/doc/) from applications written in the Ruby language.

## Basic Usage

    require 'genba'

    genba_client = Genba.client(
      username: 'api_genba_user',
      app_id: '00000000-0000-0000-0000-000000000000',
      api_key: '00000000000000000000000000000000'
    )

## Products
[Genba Products API](https://api.genbagames.com/doc/#api-Product)

Call products.get_products to get all products.

```ruby
payload = {
  countryISO: 'US',
  includeMeta: false
}

response = genba_client.products.get_products(payload)
```

Retrieve an existing product

```ruby
payload = {
  skuId: '79cf9bb2-e7f5-448f-b996-c52e4b2bb351',
  countryISO: 'US',
  includeMeta: false
}

product = genba_client.products.get_products(payload)
```

Return a list of products which have changed since a given date, including basic or advanced metadata.

```ruby
payload = {
  fromDate: 1.days.ago.strftime('%FT%T'),
  countryISO: 'US',
  includeMeta: false
}

response = genba_client.products.get_changes(payload)
```

Return a list of products which have been removed since a given date.

```ruby
payload = {
  fromDate: 1.days.ago.strftime('%FT%T'),
  countryISO: 'US',
  includeMeta: false
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

Returns a list of product sku restrictions, whitelist - can only sold in countries, blacklist - cannot be sold in countries.

```ruby
payload = {
  productId: '84d90a06-f458-4ed8-8f3d-91aa84cc6577',
  fromDate: 1.days.ago.strftime('%FT%T'),
  countryISO: 'US'
}

response = genba_client.restrictions.get_restrictions
response[:productRestriction]
```

## Keys
[Genba Keys API](https://api.genbagames.com/doc/#api-Keys)

Request Product Test Keys for a SKU

```ruby
response = genba_client.keys.get_test_keys('84d90a06-f458-4ed8-8f3d-91aa84cc6577')

response[:status]
response[:keys]
```

Request Product Keys for a SKU

```ruby
response = genba_client.keys.get_keys('84d90a06-f458-4ed8-8f3d-91aa84cc6577', 1)

response[:status]
response[:keys]
```
