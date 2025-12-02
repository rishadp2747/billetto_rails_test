class Api::Public::V1::Billetto < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :verify_webhook_signature!, only: :create
  before_action :ensure_idempotency, only: :creat


  def create
    webhook_event = WebhookEvent.create!(webhook_attributes)
    Billetto::WebhookJob.perform_async(webhook_event.id)
    head :ok
  end
  
  private

    def event_id
      @_event_id ||= params[:event_id]
    end

    def verify_webhook_signature!
      signature_header = request.headers["X-Billetto-Signature"]
      return unauthorized!("Missing signature header") if signature_header.blank?

      raw_body = request.raw_post
      secret = Rails.application.credentials.dig(:billetto, :webhook_secret)
      expected_signature = OpenSSL::HMAC.hexdigest("SHA256", secret, raw_body)

      unless secure_compare(expected_signature, signature_header)
        return unauthorized!("Invalid signature")
      end
    end

    def ensure_idempotency
      return unless WebhookEvent.exists?(identifier: event_id)

      render status: :ok 
    end

    def secure_compare(a, b)
      ActiveSupport::SecurityUtils.secure_compare(a, b)
    rescue
      false
    end

    def unauthorized!(message)
      Rails.logger.warn("[Billetto Webhook] #{message}")
      render json: { error: message }, status: :unauthorized
    end

    def webhook_attributes
      {
        identifier: event_id,
        data: params[:data],
        action: params[:action],
      }
    end
end