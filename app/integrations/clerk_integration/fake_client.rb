# frozen_string_literal: true

module ClerkIntegration
  class FakeClient
    def verify_token(token)
      return SecureRandom.uuid if token == "valid_token"

      raise ClerkIntegration::TokenInvalid, "Fake invalid token"
    end
  end
end
