# frozen_string_literal: true

require "uri"
require "cgi"

class Billetto::EventsSeederService
  CHECKPOINT_URL = "https://checkpoint.example.com/api"

  def initialize(next_url = nil)
    @next_url = next_url
  end

  def process!
    fetch_public_events!
    fetch_next_set_of_data! if has_more
    create_events_if_not_exists!
  end

  private

    attr_reader :billetto_events_data, :has_more, :next_url

    def fetch_public_events!
      after = if next_url.present?
        params = CGI.parse(URI(next_url).query)
        params["after"].first
      end

      response = BillettoIntegration.public_events_list(after:)
      @billetto_events_data = response.dig("data")
      @has_more = response.dig("has_more")
      @next_url = response.dig("next_url")

    rescue BillettoIntegration::RateLimitExceeded => e
      Rails.logger.error("Failed to fetch events data: #{e.message}")
      raise
    rescue BillettoIntegration::Error => e
      Rails.logger.error("Failed to fetch events data: #{e.message}")
    end

    def fetch_next_set_of_data!
      EventsSeederJob.perform_async(next_url)
    end

    def create_events_if_not_exists!
      error_ids = []

      billetto_events_data.each do |data|
        Billetto::Events::CreateService.new(data).process!

      rescue StandardError
        error_ids.push(data.dig("id"))
        next
      end

      unless has_more
        save_the_next_url_in_redis!(billetto_events_data.last.dig("id"))
      end

      return if error_ids.blank?

      Rails.logger.error("Failed to create the following events: #{error_ids.join(",")}")
    end

    def save_the_next_url_in_redis!(last_event_id)
      uri = URI(CHECKPOINT_URL)
      params = URI.decode_www_form(uri.query || "").to_h
      params["after"] = last_event_id.to_s
      uri.query = URI.encode_www_form(params)
      Rails.cache.write("billetto_next_url", uri.to_s)
    end
end
