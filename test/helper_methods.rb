# frozen_string_literal: true

module HelperMethods
  def json_body
    JSON.parse(response.body)
  end
end
