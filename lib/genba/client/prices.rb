# frozen_string_literal: true

module Genba
  class Client
    # Prices client
    class Prices
      def initialize(client)
        @client = client
      end

      def get_prices(params = {}, headers = {})
        payload = params.merge(
          customerAccountId: @client.customer_account_id
        )
        @client.rest_get_with_token('/prices', payload, headers)
      end
    end
  end
end
