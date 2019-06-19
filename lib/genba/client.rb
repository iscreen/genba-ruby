# frozen_string_literal: true

module Genba
  # Genba API Client
  class Client
    attr_accessor :customer_account_id,
                  :open_timeout, :read_timeout, :max_retry, :retry_delay

    API_URL = 'https://api.genbagames.com/api'.freeze

    @expires_on = nil
    @id_token = nil

    # Desribe the behaviour of the method
    #
    # ==== Attributes
    #
    # * +config+ - Genba API credential attribute
    #
    # ==== Options
    def initialize(app_id:, username:, api_key:, customer_account_id:, options: {})
      @app_id = app_id.strip
      @username = username.strip
      @api_key = api_key.strip
      @customer_account_id = customer_account_id.strip
      @open_timeout = options[:open_timeout] || 15
      @read_timeout = options[:read_timeout] || 60
      @max_retry = options[:max_retry] || 0
      @retry_delay = options[:retry_delay] || 2
    end

    def generate_token
      unless token_valid?
        body = { appId: @app_id, signature: genba_signature }
        response = RestClient.post(
          "#{API_URL}/token",
          body,
          headers: { accept: 'application/json', 'Content-Type': 'application/json' }
        )
        parsed_response = decode_json(response.body)
        @id_token = parsed_response['token']
        @expires_on = Time.parse(parsed_response['expiration'])
      end
      raw_token
    end

    def rest_get_with_token(path, query_params = {}, headers = {}, options = {})
      genba_headers = token.merge(headers)
      api_url = "#{API_URL}#{path}"
      api_url += "?#{query_params.to_query}" unless query_params.empty?
      response = execute_request(method: :get, url: api_url,
                                 headers: genba_headers, options: options)
      from_rest_client_response(response)
    end

    def rest_put_with_token(path, body = {}, headers = {}, options = {})
      genba_headers = token.merge(headers)
      response = execute_request(method: :put, url: "#{API_URL}#{path}",
                                 payload: encode_json(body), headers: genba_headers, options: options)
      from_rest_client_response(response)
    end

    def rest_post_with_token(path, body = {}, headers = {}, options = {})
      genba_headers = token.merge(headers)
      response = execute_request(method: :post, url: "#{API_URL}#{path}",
                                 payload: encode_json(body), headers: genba_headers, options: options)
      from_rest_client_response(response)
    end

    def execute_request(method:, url:, payload: {}, headers: {}, options: {})
      request_opts = {
        headers: headers,
        method: method,
        payload: payload,
        url: url
      }
      other_opts = {
        open_timeout: options[:open_timeout] || @open_timeout,
        read_timeout: options[:read_timeout] || @read_timeout,
        max_retry: options[:max_retry] || @max_retry
      }

      Genba::Util.log_debug "API Headers: #{headers.inspect}"
      Genba::Util.log_debug "Options: #{other_opts}"
      Genba::Util.log_info "#{method.upcase}: #{url}"
      Genba::Util.log_info "payload: #{payload}" if payload.present?

      request_opts.merge! other_opts
      execute_request_with_rescues(request_opts, other_opts[:max_retry])
    end

    def execute_request_with_rescues(request_opts, max_retry)
      num_try = 0
      begin
        response = RestClient::Request.execute(request_opts)
      rescue StandardError => e
        Genba::Util.log_error "#{e.class} => #{e.message}"

        num_try += 1
        sleep @retry_delay

        if num_try <= max_retry
          Genba::Util.log_error "retry ====> #{num_try}"
          retry
        end

        raise e
      end
      response
    end

    def products
      Products.new(self)
    end

    def prices
      Prices.new(self)
    end

    def restrictions
      Restrictions.new(self)
    end

    def keys
      Keys.new(self)
    end

    def direct_entitlements
      DirectEntitlements.new(self)
    end

    def reports
      Reports.new(self)
    end

    private

    def encode_json(data)
      Oj.dump(data, mode: :compat)
    end

    def decode_json(json)
      Oj.load(json)
    end

    def genba_signature
      cipher = Mcrypt.new(
        :rijndael_256,
        :cbc,
        Digest::SHA256.digest(@username),
        Digest::SHA256.digest(@app_id)
      )
      encrypted = cipher.encrypt(@api_key)
      Base64.strict_encode64(encrypted)
    end

    def raw_token
      if token_valid?
        {
          token: @id_token,
          appId: @app_id,
          accept: 'application/json',
          'Content-Type': 'application/json'
        }
      else
        {}
      end
    end

    def token
      generate_token unless token_valid?
      raw_token
    end

    def token_valid?
      @id_token && @expires_on > Time.now
    end

    def from_rest_client_response(response)
      if response.code < 200 &&
         response.code >= 400
        Genba::Util.log_error "Invalid response object from API: #{response.body}" \
            "(HTTP response code was #{response.code})"
        raise "Invalid response object from API: #{response.body}" \
              "(HTTP response code was #{response.code})"
      end
      # default decode by json
      return decode_json(response.body) unless response.headers[:content_type]
      if (response.headers[:content_type] =~ %r{application\/json}) >= 0
        Genba::Util.log_info "response body\n#{response.body}"
        decode_json(response.body)
      end
    end
  end
end
