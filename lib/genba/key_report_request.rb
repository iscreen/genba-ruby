# frozen_string_literal: true

# KeyReportRequest
class KeyReportRequest
  attr_accessor :key, :key_id, :country_iso, :sale_date, :user_ip_address,
                :e_tailer_buying_price, :e_tailer_buying_price_currency_code,
                :e_tailer_selling_price_net, :e_tailer_selling_price_gross,
                :e_tailer_selling_price_currency_code,
                :e_tailer_subsidiary

  def initialize(
    key: nil, key_id: nil, country_iso:, user_ip_address:, sale_date: nil,
    e_tailer_buying_price:, e_tailer_buying_price_currency_code:,
    e_tailer_selling_price_net:, e_tailer_selling_price_gross:, e_tailer_selling_price_currency_code:,
    e_tailer_subsidiary: nil
  )
    @key = key
    @key_id = key_id
    @country_iso = country_iso
    @user_ip_address = user_ip_address
    @sale_date = sale_date
    @e_tailer_buying_price = e_tailer_buying_price
    @e_tailer_buying_price_currency_code = e_tailer_buying_price_currency_code
    @e_tailer_selling_price_net = e_tailer_selling_price_net
    @e_tailer_selling_price_gross = e_tailer_selling_price_gross
    @e_tailer_selling_price_currency_code = e_tailer_selling_price_currency_code
    @e_tailer_subsidiary = e_tailer_subsidiary
    raise 'at least one of key or key_id' if key.nil? && key_id.nil?
  end

  def to_genba_json_payload
    payload ={
      key: @key,
      keyId: @key_id,
      countryISO: @country_iso,
      userIpAddress: @user_ip_address,
      ETailerBuyingPrice: @e_tailer_buying_price,
      ETailerBuyingPriceCurrencyCode: @e_tailer_buying_price_currency_code,
      ETailerSellingPriceNet: @e_tailer_selling_price_net,
      ETailerSellingPriceGross: @e_tailer_selling_price_gross,
      ETailerSellingPriceCurrencyCode: @e_tailer_selling_price_currency_code,
      ETailerSubsidiary: @e_tailer_subsidiary
    }.select { |_, v| !v.nil? }

    payload[:saleDate] = @sale_date.strftime('%FT%T') if @sale_date
    payload
  end
end
