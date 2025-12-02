# frozen_string_literal: true

module ClerkIntegration
  module Auth
    class << self
      def verify(token)
        response = ::Clerk::SDK.new.verify_token(token)
        response.dig("sub")

      rescue => e
        Rails.logger.warn("Clerk token verification failed: #{e.message}")
        nil
      end
    end
  end
end
