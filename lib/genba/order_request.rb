# frozen_string_literal: true

module Genba
  class OrderRequest
    def initialize
      @schema = Dry::Validation.Schema do
        required(:ClientTransactionID).filled(:str?)
        optional(:Properties).schema do
          required(:Sku).filled(:str?)
          optional(:BuyingPrice).schema do
            required(:Amount).filled(:float?)
            required(:CurrencyCode).filled(:str?)
          end
          required(:SellingPrice).schema do
            required(:NetAmount).filled(:float?)
            required(:GrossAmount).filled(:float?)
            required(:CurrencyCode).filled(:str?)
          end
          optional(:ConsumerIP).maybe(:str?)
          required(:CountryCode).filled(:str?) # require and can not be nil or empty
          optional(:EtailerID).maybe(:str?) # optional and can be nil or empty
        end
        optional(:ReservationID).filled(:str?)
      end
    end

    def call(data)
      @schema.call(data)
    end
  end
end
