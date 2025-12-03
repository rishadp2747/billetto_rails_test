# frozen_string_literal: true

module BillettoSdk
  class Api
    class TimeoutError < StandardError; end
    class ServerError < StandardError; end
    class SSLError < StandardError; end
    class ParsingError < StandardError; end
    class ConnectionFailed < StandardError; end
    class ClientError < StandardError; end
    class RateLimitExceeded < StandardError; end
    class Error < StandardError; end
  end
end
