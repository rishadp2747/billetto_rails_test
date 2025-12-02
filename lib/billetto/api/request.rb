# frozen_string_literal: true

module Billetto
  module Api
    module Request
      mattr_accessor :api_key, :secret_key, :base_url, :version

      ERROR_MAP = {
        ::Faraday::TimeoutError => Billetto::Api::TimeoutError,
        ::Faraday::ServerError => Billetto::Api::ServerError,
        ::Faraday::ClientError => Billetto::Api::ClientError,
        ::Faraday::SSLError => Billetto::Api::SSLError,
        ::Faraday::ParsingError => Billetto::Api::ParsingError,
        ::Faraday::ConnectionFailed => Billetto::Api::ConnectionFailed,
        ::Faraday::Error => Billetto::Api::Error
      }.freeze
      class << self
        def base
          url = "#{base_url}#{version}"
          headers = request_headers

          ::Faraday.new(url:, headers:) do |builder|
            builder.response :raise_error
            builder.response :json
          end
        end

        def get(endpoint)
          response = self.base.get(endpoint)
          response.body

        rescue => e
          mapped = ERROR_MAP[e.class] || Billetto::Api::Error
          raise mapped, e
        end

        private

          def request_headers
            {
              "Content-Type" => "application/json",
              "Api-Keypair" => "#{api_key}:#{secret_key}"
            }
          end
      end
    end
  end
end
