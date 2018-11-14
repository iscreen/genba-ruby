# frozen_string_literal: true

# KeyReportRequest
class KeyReportRequest
  attr_accessor :key, :key_id, :country_iso, :sale_date, :user_ip_address,
                :e_tailer_buying_price, :e_tailer_buying_price_currency_code,
                :e_tailer_selling_price_net, :e_tailer_selling_price_gross,
                :e_tailer_selling_price_currency_code

  def initialize(data = {})
    @key = data[:key]
    @key_id = data[:key_id]
    @country_iso = data[:country_iso]
    @user_ip_address = data[:user_ip_address]
    # @sale_date = data[:sale_date]
  end

  def to_genba_json_payload
    {
      key: @key,
      keyId: @key_id,
      countryISO: @country_iso,
      saleDate: @sale_date,
      userIpAddress: @user_ip_address,
      ETailerBuyingPrice: @e_tailer_buying_price,
      ETailerBuyingPriceCurrencyCode: @e_tailer_buying_price_currency_code,
      ETailerSellingPriceNet: @e_tailer_selling_price_net,
      ETailerSellingPriceGross: @e_tailer_selling_price_gross,
      ETailerSellingPriceCurrencyCode: @e_tailer_selling_price_currency_code
    }.select { |_, v| !v.nil? }
  end
end
