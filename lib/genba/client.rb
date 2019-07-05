# frozen_string_literal: true

module Genba
  # Genba API Client
  class Client
    attr_accessor :customer_account_id,
                  :open_timeout, :read_timeout, :max_retry, :retry_delay

    API_URL = 'https://sandbox.genbadigital.io/api/v3-0'.freeze

    @expires_on = nil
    @id_token = nil

    # Desribe the behaviour of the method
    #
    # ==== Attributes
    #
    # * +config+ - Genba API credential attribute
    #
    # ==== Options
    def initialize(resource:, account_id:, cert:, key:, options: {})
      @resource = resource
      @account_id = account_id
      @cert = cert
      @key = key
      @tenant = 'aad.genbadigital.io'
      @authority_url = "https://login.microsoftonline.com/#{@tenant}"
      @client_id = "https://aad-snd.genbadigital.io/#{@account_id}"

      @open_timeout = options[:open_timeout] || 15
      @read_timeout = options[:read_timeout] || 60
      @max_retry = options[:max_retry] || 0
      @retry_delay = options[:retry_delay] || 2
    end

    def generate_token
      unless token_valid?
        certificate = OpenSSL::X509::Certificate.new File.open(@cert)
        x5t = Base64.encode64 OpenSSL::Digest::SHA1.new(certificate.to_der).digest
        payload = {
          "exp": (Time.now + 60*60*24).to_i,
          "aud": "#{@authority_url}/oauth2/token",
          "iss": @client_id,
          "sub": @client_id,
        }
        rsa_private = OpenSSL::PKey::RSA.new File.open(@key)
        token = JWT.encode payload, rsa_private, 'RS256', { x5t: x5t }

        body = {
          resource: @resource,
          client_id: @client_id,
          grant_type: 'client_credentials',
          scope: 'https://graph.microsoft.com/.default',
          client_assertion_type: 'urn:ietf:params:oauth:client-assertion-type:jwt-bearer',
          client_assertion: token,
          tenant: @tenant
        }

        response = RestClient.post(
          "#{@authority_url}/oauth2/token",
          body,
          headers: { accept: 'application/json', 'Content-Type': 'application/json' }
        )
        parsed_response = decode_json(response.body)
        @id_token = parsed_response['access_token']
        @expires_on = Time.at(parsed_response['expires_on'].to_i)
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

    def raw_token
      if token_valid?
        {
          Authorization: "Bearer #{@id_token}",
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
