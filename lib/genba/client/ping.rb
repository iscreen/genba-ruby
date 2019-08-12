# frozen_string_literal: true

module Genba
  class Client
    class Ping
      def initialize(client)
        @client = client
      end

      # Test connection to the API
      def perform
        @client.rest_get_with_token('/ping', {}, {})
      end
    end
  end
end
