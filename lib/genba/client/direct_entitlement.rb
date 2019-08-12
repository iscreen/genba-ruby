# frozen_string_literal: true

module Genba
  class Client
    # DirectEntitlements client
    class DirectEntitlement
      def initialize(client)
        @client = client
      end

      def activations
        DirectEntitlement::Activations.new(@client)
      end

      def redemptions
        DirectEntitlement::Redemptions.new(@client)
      end
    end
  end
end
