# frozen_string_literal: true

class Billetto::WebhookJob
  include Sidekiq::Job

  sidekiq_options queue: :urgent, retry: false

  def perform(event_id)
    webhook_event = WebhookEvent.find_by!(identifier: event_id)
    webhook_event.processing!

    case webhook_event.action
    when "event.created"
      Stripe::Webhooks::PaymentsService.new(options).process!
    when "event.updated"
      Stripe::Webhooks::ChargesService.new(options).process!
    else
      Rails.logger.warn("Not implemented: #{webhook_event.action}")
    end
    webhook_event.processed!

  rescue StandardError => e
    webhook_event.update!(status: :failed, processing_errors: e.message&.truncate(255))
    raise
  end
end
