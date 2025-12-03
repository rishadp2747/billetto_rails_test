# frozen_string_literal: true

require "test_helper"
require "sidekiq/testing"

class Billetto::EventsSeederServiceTest < ActiveSupport::TestCase
  def setup
    Sidekiq::Testing.fake!
    EventsSeederJob.jobs.clear
  end

  def teardown
    Sidekiq::Testing.inline!
  end

  def test_seeds_events_and_schedules_another_job_if_more_events_are_available
    assert_difference "Event.count", 1 do
      Billetto::EventsSeederService.new.process!
    end

    assert_equal 1, EventsSeederJob.jobs.length
    assert_equal "https://api.example.com/events?after=123", EventsSeederJob.jobs.first["args"].first
  end

  def test_seeds_events_and_does_not_schedule_another_job_if_no_more_events_are_available
    service = Billetto::EventsSeederService.new("https://api.example.com/events?after=123")
    service.process!

    assert_equal 0, EventsSeederJob.jobs.length
  end
end
