# frozen_string_literal: true

module Genba
  class Client
    class Orders
      def initialize(client)
        @client = client
      end

      # Order a product key
      def perform(order_request, headers: {}, options: {})
        errors = Genba::OrderRequest.new.call(order_request).messages
        raise errors.inspect unless errors.empty?

        @client.rest_post_with_token('/orders', order_request, headers, options)
      end

      # Retrieve an order
      def get(order_id, headers: {})
        @client.rest_get_with_token("/orders/#{order_id}", {}, headers)
      end

      # Perform an action on a product, like ‘Return’
      def perform_action(order_id, action_request, headers: {}, options: {})
        errors = Genba::ActionRequest.new.call(action_request).messages
        raise errors.inspect unless errors.empty?

        @client.rest_post_with_token("/orders/#{order_id}", action_request, headers)
      end

      # Retrieve and order based on your Client transaction ID
      def get_by_ctid(ctid, headers: {})
        @client.rest_get_with_token("/orders/ctid/#{ctid}", {}, headers)
      end
    end
  end
end
