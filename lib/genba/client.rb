# frozen_string_literal: true

module Genba
  # Genba API Client
  class Client
    attr_accessor :customer_account_id

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
    def initialize(app_id:, username:, api_key:, customer_account_id:)
      @app_id = app_id.strip
      @username = username.strip
      @api_key = api_key.strip
      @customer_account_id = customer_account_id.strip
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

    def rest_get_with_token(path, query_params = {}, headers = {})
      genba_headers = token.merge(headers)
      Genba::Util.log_debug "API Headers: #{genba_headers.inspect}"
      api_url = "#{API_URL}#{path}"
      api_url += "?#{query_params.to_query}" unless query_params.empty?
      Genba::Util.log_info "api_url: #{api_url}"
      response = RestClient.get(api_url, genba_headers)
      from_rest_client_response(response)
    end

    def rest_put_with_token(path, body = {}, headers = {})
      genba_headers = token.merge(headers)
      Genba::Util.log_debug "API Headers: #{genba_headers.inspect}"
      Genba::Util.log_info "api_url: #{API_URL}#{path}"
      response = RestClient.put("#{API_URL}#{path}", encode_json(body), genba_headers)
      from_rest_client_response(response)
    end

    def rest_post_with_token(path, body = {}, headers = {})
      genba_headers = token.merge(headers)
      Genba::Util.log_debug "API Headers: #{genba_headers.inspect}"
      Genba::Util.log_info "api_url: #{API_URL}#{path}"
      Genba::Util.log_info "body: #{body}"
      response = RestClient.post("#{API_URL}#{path}", encode_json(body), genba_headers)
      from_rest_client_response(response)
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
