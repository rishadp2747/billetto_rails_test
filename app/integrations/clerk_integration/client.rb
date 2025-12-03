# frozen_string_literal: true

module ClerkIntegration
  class Client
    def initialize
      @clerk_sdk = ::Clerk::SDK.new
    end

    def verify_token(token)
      verification = clerk_sdk.verify_token(token)
      verification&.dig("sub")
    end

    private

      attr_reader :clerk_sdk
  end
end
