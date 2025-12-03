# frozen_string_literal: true

require "uri"

module BillettoSdk
  class Api
    module PublicEvents
      mattr_accessor :request

      class << self
        ENDPOINT = "public/events"

        def list(after: nil, limit: 100)
          params = { limit: limit }
          params[:after] = after if after.present?
          query_string = URI.encode_www_form(params)
          url = "#{ENDPOINT}?#{query_string}"

          request.get(url)
        end
      end
    end
  end
end
