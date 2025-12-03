# frozen_string_literal: true

module ClerkIntegration
  module Auth
    class << self
      def verify(token)
        user_id = ClerkIntegration.client.verify_token(token)
        return user_id if user_id.present?

        raise ClerkIntegration::TokenInvalid, "Invalid token"
      rescue Clerk::ConfigurationError => e
        raise ClerkIntegration::ConfigurationMissing, e.message
      rescue Clerk::ApiError, Clerk::NetworkError => e
        raise ClerkIntegration::APIUnavailable, e.message
      rescue => e
        raise ClerkIntegration::Error, "Unexpected Clerk error: #{e.message}"
      end
    end
  end
end
