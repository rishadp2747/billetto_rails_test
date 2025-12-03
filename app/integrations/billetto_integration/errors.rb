# frozen_string_literal: true

module BillettoIntegration
  # Map SDK errors to integration errors
  class Error < StandardError; end
  class TimeoutError < Error; end
  class ServerError < Error; end
  class SSLError < Error; end
  class ParsingError < Error; end
  class ConnectionFailed < Error; end
  class ClientError < Error; end
  class RateLimitExceeded < Error; end

  ERROR_MAP = {
    BillettoSdk::Api::TimeoutError => BillettoIntegration::TimeoutError,
    BillettoSdk::Api::ServerError => BillettoIntegration::ServerError,
    BillettoSdk::Api::SSLError => BillettoIntegration::SSLError,
    BillettoSdk::Api::ParsingError => BillettoIntegration::ParsingError,
    BillettoSdk::Api::ConnectionFailed => BillettoIntegration::ConnectionFailed,
    BillettoSdk::Api::ClientError => BillettoIntegration::ClientError,
    BillettoSdk::Api::RateLimitExceeded => BillettoIntegration::RateLimitExceeded,
    BillettoSdk::Api::Error => BillettoIntegration::Error
  }.freeze

  def self.map_error(error)
    ERROR_MAP[error.class] || BillettoIntegration::Error
  end
end
