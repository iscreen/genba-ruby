# frozen_string_literal: true

module Genba
  class Client
    class Products
      def initialize(client)
        @client = client
      end

      # Return information about a product
      def get(sku_id, headers: {})
        payload = {
        }.select { |_, v| !v.nil? }

        @client.rest_get_with_token("/products/#{sku_id}", payload, headers)
      end

      # Gets a collection of available products
      def list(country_code: nil, include_meta: nil, from_date: nil, deleted: nil, continuation_token: nil, headers: {})
        payload = {
          countryCode: country_code,
          includeMeta: include_meta,
          fromDate: from_date,
          deleted: deleted,
          continuationtoken: continuation_token
        }.select { |_, v| !v.nil? }

        @client.rest_get_with_token('/products', payload, headers)
      end
    end
  end
end
