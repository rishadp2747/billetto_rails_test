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
      user_id = ClerkIntegration.verify_token(token)
      return @current_user_id = user_id if user_id.present?

      render json: { error: "Invalid token" }, status: :unauthorized
    end
end
