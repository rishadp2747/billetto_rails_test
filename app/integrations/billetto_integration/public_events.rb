# frozen_string_literal: true

module BillettoIntegration
  module PublicEvents
    class << self
      def list(after: nil, limit: 100)
        BillettoIntegration.client.public_events(after:, limit:)

      rescue BillettoSdk::Api::Error => e
        mapped_error = BillettoIntegration.map_error(e)
        raise mapped_error, e.message
      end
    end
  end
end
