# frozen_string_literal: true

module Genba
  class Client
    # Restrictions client
    class Restrictions
      def initialize(client)
        @client = client
      end

      def get_restrictions(product_id: nil, country_iso: nil, from_date: nil, params: {}, headers: {})
        payload = params.merge(
          productId: product_id,
          countryISO: country_iso
        ).select { |_, v| !v.nil? }
        payload[:fromDate] = from_date.strftime('%FT%T') if from_date
        @client.rest_get_with_token('/restrictions', payload, headers)
      end
    end
  end
end
