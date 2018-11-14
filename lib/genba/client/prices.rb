# frozen_string_literal: true

module Genba
  class Client
    # Prices client
    class Prices
      def initialize(client)
        @client = client
      end

      def get_prices(params = {}, headers = {})
        @client.rest_get_with_token('/prices', params, headers)
      end
    end
  end
end
