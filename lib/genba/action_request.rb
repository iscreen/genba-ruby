# frozen_string_literal: true

module Genba
  class ActionRequest
    def initialize
      @schema = Dry::Validation.Schema do
        required(:Action).filled(:str?)
        optional(:Reason).filled(:str?)
      end
    end

    def call(data)
      @schema.call(data)
    end
  end
end
