# frozen_string_literal: true

module BillettoIntegration
  class << self
    def client
      Rails.configuration.billetto_adapter
    end

    def public_events_list(after: nil, limit: 100)
      PublicEvents.list(after: after, limit: limit)
    end
  end
end
