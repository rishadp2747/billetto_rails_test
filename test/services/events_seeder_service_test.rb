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

  def test_saves_checkpoint_to_redis_when_has_more_is_false
    Rails.cache.delete("billetto_next_url")
    service = Billetto::EventsSeederService.new("https://api.example.com/events?after=123")
    service.process!

    saved_url = Rails.cache.read("billetto_next_url")
    assert_not_nil saved_url, "Checkpoint URL should be saved to Redis"

    uri = URI.parse(saved_url)
    params = URI.decode_www_form(uri.query || "").to_h
    assert_equal "125", params["after"], "Checkpoint should contain the last event ID"
    assert_equal Billetto::EventsSeederService::CHECKPOINT_URL, "#{uri.scheme}://#{uri.host}#{uri.path}"
  end
end
