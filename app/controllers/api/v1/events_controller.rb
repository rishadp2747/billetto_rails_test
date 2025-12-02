# frozen_string_literal: true

class Api::V1::EventsController < ApplicationController
  include ::Pagy::Backend
  def index
    @pagy, @events = pagy(Event.order(startdate: :desc))
  end
end
