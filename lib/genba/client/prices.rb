# frozen_string_literal: true

module Genba
  class Client
    class Prices
      def initialize(client)
        @client = client
      end

      # Gets a collection of prices
      def list(continuation_token: nil, params: {}, headers: {})
        payload = {
          continuationtoken: continuation_token
        }.select { |_, v| !v.nil? }.merge(params)

        @client.rest_get_with_token('/prices', payload, headers)
      end
    end
  end
end
