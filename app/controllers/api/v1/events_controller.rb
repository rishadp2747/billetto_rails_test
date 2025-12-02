# frozen_string_literal: true

class Api::V1::EventsController < Api::V1::BaseController
  def index
    @pagy, @events = pagy(ordered_events)
  end

  private

    def ordered_events
      Event.includes(:event_vote_count).order(startdate: :desc)
    end
end
