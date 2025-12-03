# frozen_string_literal: true

module BillettoSdk
  class Api
    class Request
      ERROR_MAP = {
        ::Faraday::TimeoutError => BillettoSdk::Api::TimeoutError,
        ::Faraday::ServerError => BillettoSdk::Api::ServerError,
        ::Faraday::ClientError => BillettoSdk::Api::ClientError,
        ::Faraday::SSLError => BillettoSdk::Api::SSLError,
        ::Faraday::ParsingError => BillettoSdk::Api::ParsingError,
        ::Faraday::ConnectionFailed => BillettoSdk::Api::ConnectionFailed,
        ::Faraday::Error => BillettoSdk::Api::Error
      }.freeze

      attr_reader :api_key, :secret_key, :base_url, :version

      def initialize(api_key:, secret_key:, base_url:, version:)
        @api_key = api_key
        @secret_key = secret_key
        @base_url = base_url
        @version = version
      end

      def get(endpoint)
        response = connection.get(endpoint)
        response.body
      rescue => e
        if e.respond_to?(:response) && e.response&.status == 429
          raise BillettoSdk::Api::RateLimitExceeded, e
        end

        mapped = ERROR_MAP[e.class] || BillettoSdk::Api::Error
        raise mapped, e
      end

      private

        def connection
          url = "#{base_url}#{version}"
          headers = request_headers

          ::Faraday.new(url:, headers:) do |builder|
            builder.response :raise_error
            builder.response :json
          end
        end

        def request_headers
          {
            "Content-Type" => "application/json",
            "Api-Keypair" => "#{api_key}:#{secret_key}"
          }
        end
    end
  end
end
