# frozen_string_literal: true

module Genba
  class Client
    # Reports client
    class Reports
      def initialize(client)
        @client = client
      end

      def publisher_raw_data(year = nil, params = {}, headers = {})
        payload = params.merge({
          Year: year || Time.now.strftime('%Y')
        })
        @client.rest_get_with_token('/report/publisher/rawdata', payload, headers)
      end
    end
  end
end
