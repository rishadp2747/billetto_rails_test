# frozen_string_literal: true

Clerk.configure do |c|
  c.secret_key = Rails.application.credentials.dig(:clerk, :secret_key)
  c.publishable_key = Rails.application.credentials.dig(:clerk, :publishable_key)
end
