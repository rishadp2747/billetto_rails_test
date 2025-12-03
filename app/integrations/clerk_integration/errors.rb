# frozen_string_literal: true

module ClerkIntegration
  class Error < StandardError; end
  class TokenInvalid < Error; end
  class APIUnavailable < Error; end
  class ConfigurationMissing < Error; end
end
