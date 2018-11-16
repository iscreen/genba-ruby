# frozen_string_literal: true

module Genba
  class Client
    # Keys client
    class Keys
      def initialize(client)
        @client = client
      end

      def get_test_keys(sku_id, headers = {})
        params = {
          skuId: sku_id
        }
        @client.rest_get_with_token('/testKeys', params, headers)
      end

      def get_keys(sku_id, quantity = 1, params = {}, headers = {})
        payload = params.merge(
          skuId: sku_id,
          quantity: quantity
        )
        @client.rest_get_with_token('/keys', payload, headers)
      end

      def get_key_code_status(key_code, params = {}, headers = {})
        payload = params.merge(
          keyCode: key_code
        )
        @client.rest_get_with_token('/keys', payload, headers)
      end

      def get_key_status(key_id, params = {}, headers = {})
        @client.rest_get_with_token("/keys/#{key_id}", params, headers)
      end

      def get_report_usage(keys = nil, headers = {})
        raise 'ReportUsage keys should be array' unless keys.is_a?(Array)
        raise 'ReportUseag keys should be a KeyReportRequest class' unless key_report_request?(keys)
        payload = keys.map(&:to_genba_json_payload)
        @client.rest_post_with_token('/keyReport', payload, headers)
      end

      def black_list(keys = nil, headers = {})
        raise 'Blacklist keys should be array' unless keys.is_a?(Array)
        raise 'Blacklist keys should be a KeyBlackListRequest class' unless key_black_list_request?(keys)

        keys.each do |k|
          raise k.errors.full_messages.to_s unless k.valid?
        end

        payload = keys.map(&:to_genba_json_payload)
        @client.rest_post_with_token('/blackListKeys', payload, headers)
      end

      private

      def key_report_request?(keys)
        (keys.map { |k| k.is_a?(KeyReportRequest) } & [false]).empty?
      end

      def key_black_list_request?(keys)
        (keys.map { |k| k.is_a?(KeyBlackListRequest) } & [false]).empty?
      end
    end
  end
end
