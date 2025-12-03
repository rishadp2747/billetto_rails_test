# frozen_string_literal: true

Rails.configuration.to_prepare do
  BillettoSdk::Api.version = "v3"
  BillettoSdk::Api.base_url = "https://billetto.dk/api/"
  BillettoSdk::Api.api_key = Rails.application.credentials.dig(:billetto, :api_key)
  BillettoSdk::Api.secret_key = Rails.application.credentials.dig(:billetto, :secret_key)

  if Rails.env.test?
    Rails.configuration.billetto_adapter = BillettoIntegration::FakeClient.new
  else
    Rails.configuration.billetto_adapter = BillettoIntegration::Client.new
  end
end
