# frozen_string_literal: true

module Genba
  class Client
    class Promotions
      def initialize(client)
        @client = client
      end

      # Gets a collection of available promotions
      def list(from_date: nil, to_date: nil, continuation_token: nil, headers: {})
        payload = {
          fromDate: from_date,
          toDate: to_date,
          continuationtoken: continuation_token
        }.select { |_, v| !v.nil? }

        @client.rest_get_with_token('/promotions', payload, headers)
      end
    end
  end
end
