# frozen_string_literal: true

module Genba
  class Client
    # Restrictions client
    class Restrictions
      def initialize(client)
        @client = client
      end

      def get_restrictions(params = {}, headers = {})
        @client.rest_get_with_token('/restrictions', params, headers)
      end
    end
  end
end
