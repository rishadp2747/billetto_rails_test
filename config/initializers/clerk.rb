# frozen_string_literal: true

Clerk.configure do |c|
  c.secret_key = Rails.application.credentials.dig(:clerk, :secret_key)
  c.publishable_key = Rails.application.credentials.dig(:clerk, :publishable_key)
end

Rails.configuration.to_prepare do
  if Rails.env.test?
    Rails.configuration.clerk_adapter = ClerkIntegration::FakeClient.new
  else
    Rails.configuration.clerk_adapter = ClerkIntegration::Client.new
  end
end
