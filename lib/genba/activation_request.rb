# frozen_string_literal: true

module Genba
  class ActivationRequest
    def initialize
      @schema = Dry::Validation.Schema do
        required(:ClientTransactionID).filled(:str?)
        optional(:EtailerID).filled(:str?)
        required(:Activation).schema do
          required(:Sku).filled(:str?)
          required(:CountryCode).filled(:str?)
          optional(:ConsumerIP).maybe(:str?)
          optional(:BuyingPrice).schema do
            required(:Amount).filled(:float?)
            required(:CurrencyCode).filled(:str?)
          end
          required(:SellingPrice).schema do
            required(:NetAmount).filled(:float?)
            required(:GrossAmount).filled(:float?)
            required(:CurrencyCode).filled(:str?)
          end
          optional(:EtailerID).maybe(:str?)
        end
        optional(:Redemption).schema do
          required(:EndUserID).filled(:str?)
          required(:EndUserTicket).filled(:str?)
        end
      end
    end

    def call(data)
      @schema.call(data)
    end
  end
end
