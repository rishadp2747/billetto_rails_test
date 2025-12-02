# frozen_string_literal: true

class Billetto::Events::CreateService < Billetto::Events::BaseService
  def process
    unless Event.exists?(identifier:)
      find_or_create_organization!
      find_or_create_organiser!
      create_event!
    end
  end

  private

    def create_event!
      Event.create!(event_attributes)
    end
end
