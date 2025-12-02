# frozen_string_literal: true

class Api::V1::BaseController < ApplicationController
  include ClerkAuthenticatable
  include ::Pagy::Backend
end
