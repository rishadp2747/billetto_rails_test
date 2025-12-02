# frozen_string_literal: true

module ApplicationHelper
  def get_client_props
    {
      clerk_publishable_key: Rails.application.credentials.dig(:clerk, :publishable_key)
    }
  end
end
