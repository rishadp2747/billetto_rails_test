# frozen_string_literal: true

module ClerkIntegration
  class << self
    def client
      Rails.configuration.clerk_adapter
    end

    def verify_token(token)
      Auth.verify(token)
    end
  end
end
