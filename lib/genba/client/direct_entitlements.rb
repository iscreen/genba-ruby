# frozen_string_literal: true

module Genba
  class Client
    # DirectEntitlements client
    class DirectEntitlements
      def initialize(client)
        @client = client
      end

      def activate(sku_id, e_tailer_selling_price_net, e_tailer_selling_price_gross, headers = {})
        params = {
          skuId: sku_id,
          ETailerSellingPriceNet: e_tailer_selling_price_net,
          ETailerSellingPriceGross: e_tailer_selling_price_gross
        }
        @client.rest_get_with_token('/directentitlement/activate', params, headers)
      end

      # Use this method to redeem keys already sold for a Direct Entitlement SKU and link them to the
      # end-user's account. You will not be charged at the point of calling this method.
      def redeem(sku_id, key_id, end_user_id, end_user_ticket, headers = {})
        params = {
          skuId: sku_id,
          keyId: key_id,
          endUserId: end_user_id,
          endUserTicket: end_user_ticket
        }
        @client.rest_get_with_token('/directentitlement/redeem', params, headers)
      end
    end
  end
end
