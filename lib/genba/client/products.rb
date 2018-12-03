# frozen_string_literal: true

module Genba
  class Client
    # Products client
    class Products
      def initialize(client)
        @client = client
      end

      def get_products(sku_id: nil, country_iso: nil, include_meta: false, headers: {})
        payload = {
          skuId: sku_id,
          countryISO: country_iso,
          includeMeta: include_meta
        }.select { |_, v| !v.nil? }

        @client.rest_get_with_token('/product', payload, headers)
      end

      def get_changes(from_date: nil, country_iso: nil, include_meta: false, params: {}, headers: {})
        payload = params.merge(
          countryISO: country_iso,
          includeMeta: include_meta
        ).select { |_, v| !v.nil? }
        payload[:fromDate] = from_date.strftime('%FT%T') if from_date
        @client.rest_get_with_token('/product/changes', payload, headers)
      end

      def get_removed(from_date: nil, country_iso: nil, params: {}, headers: {})
        payload = params.merge(
          countryISO: country_iso,
          customerAccountId: @client.customer_account_id
        ).select { |_, v| !v.nil? }
        payload[:fromDate] = from_date.strftime('%FT%T') if from_date
        @client.rest_get_with_token('/product/removed', payload, headers)
      end
    end
  end
end
