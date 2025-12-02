# frozen_string_literal: true

class WebhookEvent < ApplicationRecord
  enum :status, { pending: "pending", processing: "processing", processed: "processed", failed: "failed" },
    default: :pending

  validates :identifier, presence: true, uniqueness: true
  validates :action, presence: true
end
