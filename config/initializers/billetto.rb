# frozen_string_literal: true

Rails.configuration.to_prepare do
  Billetto::Api::Request.version = "v3"
  Billetto::Api::Request.base_url = "https://billetto.dk/api/"
  Billetto::Api::Request.api_key = Rails.application.credentials.dig(:billetto, :api_key)
  Billetto::Api::Request.secret_key = Rails.application.credentials.dig(:billetto, :secret_key)
end
