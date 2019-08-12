# frozen_string_literal: true

module Genba
  class RedemptionRequest
    def initialize
      @schema = Dry::Validation.Schema do
        required(:ClientTransactionID).filled(:str?)
        optional(:EtailerID).filled(:str?)
        required(:ActivationID).filled(:str?)
        required(:Redemption).schema do
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
