# frozen_string_literal: true

module HelperMethods
  def json_body
    JSON.parse(response.body)
  end

  def valid_headers
    @_valid_headers ||= { "Authorization" => "Bearer valid_token" }
  end

  def invalid_headers
    @_invalid_headers ||= { "Authorization" => "Bearer invalid_token" }
  end
end
