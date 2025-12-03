# frozen_string_literal: true

module ClerkAuthenticatable
  extend ActiveSupport::Concern

  included do
    attr_reader :current_user_id

    protect_from_forgery with: :null_session

    before_action :verify_header!
    before_action :authenticate_user!
  end

  private

    def verify_header!
      @header = request.headers["Authorization"]
      return if @header&.start_with?("Bearer ")

      render json: { error: "No token" }, status: :unauthorized
    end

    def authenticate_user!
      token = @header.split(" ").last
      @current_user_id = ClerkIntegration.verify_token(token)

    rescue ClerkIntegration::TokenInvalid => e
      render json: { error: e.message }, status: :unauthorized
    rescue ClerkIntegration::APIUnavailable => e
      render json: { error: e.message }, status: :service_unavailable
    rescue ClerkIntegration::ConfigurationMissing => e
      render json: { error: e.message }, status: :internal_server_error
    rescue ClerkIntegration::Error => e
      render json: { error: e.message }, status: :internal_server_error
    end
end
