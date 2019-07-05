# frozen_string_literal: true

module Genba
  class Client
    class Reservations
      def initialize(client)
        @client = client
      end

      # Place a reservation for a product
      def perform(reservation_request, headers: {}, options: {})
        errors = Genba::ReservationRequest.new.call(reservation_request).messages
        raise errors.inspect unless errors.empty?

        @client.rest_post_with_token('/reservations', reservation_request, headers, options)
      end

      # Retrieve a reservation
      def get(reservation_id, headers: {})
        payload = {
        }.select { |_, v| !v.nil? }

        @client.rest_get_with_token("/reservations/#{reservation_id}", payload, headers)
      end
    end
  end
end
