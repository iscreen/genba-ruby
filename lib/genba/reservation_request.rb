# frozen_string_literal: true

module Genba
  class ReservationRequest
    def initialize
      @schema = Dry::Validation.Schema do
        required(:ClientTransactionID).filled(:str?)
        required(:Properties).schema do
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
          required(:CountryCode).filled(:str?)
          optional(:EtailerID).maybe(:str?)
        end
      end
    end

    def call(data)
      @schema.call(data)
    end
  end
end
