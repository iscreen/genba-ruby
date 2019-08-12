# Genba Ruby

[![Build Status](https://travis-ci.org/iscreen/genba-ruby.svg)](https://travis-ci.org/iscreen/genba-ruby)
[![CircleCI](https://circleci.com/gh/iscreen/genba-ruby.svg?style=svg)](https://circleci.com/gh/iscreen/genba-ruby)
[![Gem Version](https://badge.fury.io/rb/genba-ruby.svg)](https://badge.fury.io/rb/genba-ruby)

The Genba Library provides convenient access to the [Genba API V3](https://sandbox.genbadigital.io/doc) from applications written in the Ruby language.
  * [Genba Digital](https://genbadigital.com/)
  * [Genba API V2](https://api.genbagames.com/doc/)
  * [Genba API V3 Sandbox](https://sandbox.genbadigital.io/doc/)
  * [Genba API V3 Production](https://unknown.genbadigital.io/doc)

## Basic Usage

```ruby
require 'genba-ruby'

GENBA = Genba.client(
  resource: 'resource-0000-0000-0000-000000000000',
  account_id: 'account0-0000-0000-0000-000000000000',
  cert: 'your.domain.crt',
  key: 'your.domain.key',
  sandbox: true # default: false
)
```

## Ping
[Genba Ping API](https://sandbox.genbadigital.io/doc/#/Ping)

## Products
[Genba Products API](https://sandbox.genbadigital.io/doc/#/Products)

## Prices
[Genba Prices API](https://sandbox.genbadigital.io/doc/#/Prices)

## Promotions
[Genba Promotions API](https://sandbox.genbadigital.io/doc/#/Promotions)

## Reservations
[Genba Reservations API](https://sandbox.genbadigital.io/doc/#/Reservations)

## Orders
[Genba Orders API](https://sandbox.genbadigital.io/doc/#/Orders)

## DirectEntitlement
[Genba DirectEntitlement API](https://sandbox.genbadigital.io/doc/#/DirectEntitlement)
