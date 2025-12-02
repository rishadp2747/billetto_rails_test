# frozen_string_literal: true

module Billetto
  module Api
    module PublicEvents
      class << self
        ENDPOINT = "public/events"

        def list(after: nil, limit: 100)
          params = { limit: limit }
          params[:after] = after if after.present?
          query_string = URI.encode_www_form(params)
          url = "#{ENDPOINT}?#{query_string}"
          Request.get(url)
        end
      end
    end
  end
end
