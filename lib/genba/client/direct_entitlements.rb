# frozen_string_literal: true

module Genba
  class Client
    # DirectEntitlements client
    class DirectEntitlements
      def initialize(client)
        @client = client
      end

      def activate(sku_id, headers = {})
        params = {
          skuId: sku_id
        }
        @client.rest_get_with_token('/directentitlement/activate', params, headers)
      end

      # Use this method to redeem keys already sold for a Direct Entitlement SKU and link them to the
      # end-user's account. You will not be charged at the point of calling this method.
      def redeem(sku_id, key_id, headers = {})
        params = {
          skuId: sku_id,
          keyId: key_id
        }
        @client.rest_get_with_token('/directentitlement/redeem', params, headers)
      end
    end
  end
end
