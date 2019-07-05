# frozen_string_literal: true

module Genba
  class Client
    class DirectEntitlement
      # DirectEntitlement Activations client
      class Activations
        def initialize(client)
          @client = client
        end

        # Perform a direct entitlement activation
        def perform(activation_request, headers: {}, options: {})
          errors = Genba::ActivationRequest.new.call(activation_request).messages
          raise errors.inspect unless errors.empty?

          @client.rest_post_with_token('/directentitlement/activations', activation_request, headers, options)
        end

        # Retrieve a direct entitlement activation
        def get(activation_id, headers: {})
          @client.rest_get_with_token("/directentitlement/activations/#{activation_id}", {}, headers)
        end

        # Perform an action on an activation
        def perform_action(activation_id, action_request, headers: {}, options: {})
          errors = Genba::ActionRequest.new.call(action_request).messages
          raise errors.inspect unless errors.empty?

          @client.rest_post_with_token("/directentitlement/activations/#{activation_id}", action_request, headers)
        end

        # Retrieve a direct entitlement activation by its Client Transaction ID
        def get_by_ctid(ctid, headers: {})
          @client.rest_get_with_token("/directentitlement/activations/ctid/#{ctid}", {}, headers)
        end
      end
    end
  end
end
