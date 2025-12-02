# frozen_string_literal: true

module Billetto
  module Api
    class TimeoutError < StandardError; end
    class ServerError < StandardError; end
    class SSLError < StandardError; end
    class ParsingError < StandardError; end
    class ConnectionFailed < StandardError; end
    class Error < StandardError; end
  end
end
