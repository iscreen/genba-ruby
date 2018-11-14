# frozen_string_literal: true

module Genba
  class Client
    # Products client
    class Products
      def initialize(client)
        @client = client
      end

      def get_products(params = {}, headers = {})
        @client.rest_get_with_token('/product', params, headers)
      end

      def get_changes(from_date, params = {}, headers = {})
        payload = params.merge(
          fromDate: from_date.strftime('%FT%T')
        )
        @client.rest_get_with_token('/product/changes', payload, headers)
      end

      def get_removed(from_date, params = {}, headers = {})
        payload = params.merge(
          fromDate: from_date.strftime('%FT%T')
        )
        @client.rest_get_with_token('/product/removed', payload, headers)
      end
    end
  end
end
