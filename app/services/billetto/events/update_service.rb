# frozen_string_literal: true

class Billetto::Events::UpdateService < Billetto::Events::BaseService
  def process
    return unless event

    find_or_create_organization!
    find_or_create_organiser!
    update_event!
  end

  private

    def event
      @_event ||= Event.find_by(identifier:)
    end

    def update_event!
      event.update!(event_attributes)
    end
end
