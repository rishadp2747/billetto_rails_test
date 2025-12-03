# frozen_string_literal: true

class EventsSeederJob
  include Sidekiq::Job

  def perform(next_url = nil)
    next_url = Rails.cache.read("billetto_next_url") unless next_url.present?
    Billetto::EventsSeederService.new(next_url).process!
  end
end
