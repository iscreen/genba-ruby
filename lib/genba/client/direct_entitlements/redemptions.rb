# frozen_string_literal: true

module Genba
  class Client
    class DirectEntitlement
      # DirectEntitlement Redemptions client
      class Redemptions
        def initialize(client)
          @client = client
        end

        # Perform a direct entitlement redemption
        def perform(redemption_request, headers: {}, options: {})
          errors = Genba::RedemptionRequest.new.call(redemption_request).messages
          raise errors.inspect unless errors.empty?

          @client.rest_post_with_token('/directentitlement/redemptions', redemption_request, headers, options)
        end

        # Retrieve a direct entitlement redemption
        def get(redemption_id, headers: {})
          @client.rest_get_with_token("/directentitlement/redemptions/#{redemption_id}", {}, headers)
        end

        # Perform an action on an redemption
        def perform_action(redemption_id, action_request, headers: {}, options: {})
          errors = Genba::ActionRequest.new.call(action_request).messages
          raise errors.inspect unless errors.empty?

          @client.rest_post_with_token("/directentitlement/redemptions/#{redemption_id}", action_request, headers)
        end

        # Retrieve a direct entitlement redemption by its Client Transaction ID
        def get_by_ctid(ctid, headers: {})
          @client.rest_get_with_token("/directentitlement/redemptions/ctid/#{ctid}", {}, headers)
        end
      end
    end
  end
end
