# frozen_string_literal: true

namespace :setup do
  desc "Schedule EventsSeederJob if no events exist"
  task seed_events: :environment do
    if Event.count.zero?
      puts "No events found. Scheduling EventsSeederJob..."
      EventsSeederJob.perform_async
      puts "EventsSeederJob scheduled successfully."
    else
      puts "Events already exist. Skipping EventsSeederJob scheduling."
    end
  end
end

