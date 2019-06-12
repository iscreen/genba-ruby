# frozen_string_literal: true

module Genba
  class Client
    # DirectEntitlements client
    class DirectEntitlements
      def initialize(client)
        @client = client
      end

      def activate(
        sku_id:,
        country_iso:,
        end_user_ip_address:,
        sale_date: DateTime.now,
        end_user_id: nil,
        end_user_ticket: nil,
        e_tailer_buying_price:,
        e_tailer_buying_price_currency_code:,
        e_tailer_selling_price_net:,
        e_tailer_selling_price_gross:,
        e_tailer_selling_price_currency_code:,
        headers: {},
        options: {}
      )
        params = {
          skuId: sku_id,
          customerAccountId: @client.customer_account_id,
          countryISO: country_iso,
          endUserIpAddress: end_user_ip_address,
          endUserId: end_user_id,
          endUserTicket: end_user_ticket,
          ETailerBuyingPrice: e_tailer_buying_price,
          ETailerBuyingPriceCurrencyCode: e_tailer_buying_price_currency_code,
          ETailerSellingPriceNet: e_tailer_selling_price_net,
          ETailerSellingPriceGross: e_tailer_selling_price_gross,
          ETailerSellingPriceCurrencyCode: e_tailer_selling_price_currency_code
        }.select { |_, v| !v.nil? }
        params[:saleDate] = sale_date.strftime('%FT%T') if sale_date
        Genba::Util.log_debug "DirectEntitlements activate payload: #{params.inspect}"
        @client.rest_get_with_token('/directentitlement/activate', params, headers, options)
      end

      # Use this method to redeem keys already sold for a Direct Entitlement SKU and link them to the
      # end-user's account. You will not be charged at the point of calling this method.
      def redeem(sku_id:, key_id:, end_user_id:, end_user_ticket:, headers: {}, options: {})
        params = {
          customerAccountId: @client.customer_account_id,
          skuId: sku_id,
          keyId: key_id,
          endUserId: end_user_id,
          endUserTicket: end_user_ticket
        }
        @client.rest_get_with_token('/directentitlement/redeem', params, headers, options)
      end
    end
  end
end
