# frozen_string_literal: true

module BillettoIntegration
  class Client
    def initialize
      @billetto_api = BillettoSdk::Api.new
    end

    def public_events(after: nil, limit: 100)
      billetto_api.public_events.list(after: after, limit: limit)
    end

    private

      attr_reader :billetto_api
  end
end
