# frozen_string_literal: true

require_relative "api/errors"
require_relative "api/request"

module BillettoSdk
  class Api
    mattr_accessor :api_key, :secret_key, :base_url, :version

    def initialize(api_key: nil, secret_key: nil, base_url: nil, version: nil)
      @api_key = api_key || self.class.api_key
      @secret_key = secret_key || self.class.secret_key
      @base_url = base_url || self.class.base_url
      @version = version || self.class.version
      @request = Api::Request.new(api_key: @api_key, secret_key: @secret_key, base_url: @base_url, version: @version)
    end

    def public_events
      Api::PublicEvents.request = request
      Api::PublicEvents
    end

    private

      attr_reader :request
  end
end
