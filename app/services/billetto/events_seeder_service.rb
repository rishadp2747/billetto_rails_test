# frozen_string_literal: true

require "uri"
require "cgi"

class Billetto::EventsSeederService
  CUSTOM_ATTRIBUTES = %w[id identifier organiser organization].freeze

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

      response = Billetto::Api::PublicEvents.list(after:)
      @billetto_events_data = response.dig("data")
      @has_more = response.dig("has_more")
      @next_url = response.dig("next_url")

    rescue Billetto::Api::ClientError => e
      raise if e.response[:status] == 429

      Rails.logger.error("Failed to fetch events data: #{e.error.message}")
    end

    def fetch_next_set_of_data!
      EventsSeederJob.perform_async(next_url)
    end

    def create_events_if_not_exists!
      error_ids = []

      billetto_events_data.each do |data|
        Billetto::Events::CreateService.new(data).process!
      rescue StandardError => e
        error_ids.push(data.dig("id"))
        next
      end

      return if error_ids.blank?

      Rails.logger.error("Failed to create the following events: #{error_ids.join(",")}")
    end
end
