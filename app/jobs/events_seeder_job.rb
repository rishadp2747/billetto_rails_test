# frozen_string_literal: true

class EventsSeederJob
  include Sidekiq::Job

  def perform(next_url = nil)
    EventsSeederService.new(next_url).process!
  end
end
