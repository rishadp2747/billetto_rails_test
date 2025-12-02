# frozen_string_literal: true

require "uri"
require "cgi"

class EventsSeederService
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

      Rails.logger("Failed to fetch events data: #{e.error.message}")
    end

    def fetch_next_set_of_data!
      EventsSeederJob.perform_async(next_url)
    end

    def create_events_if_not_exists!
      error_ids = []

      billetto_events_data.each do |data|
        organization = find_or_create_organization!(data)
        organiser = find_or_create_organiser!(data)
        find_or_create_event!(data, organization.id, organiser.id)

        StandardError => e
        error_ids.push(data.dig("id"))
        next
      end

      return if error_ids.blank?

      Rails.logger("Failed to create the following events: #{error_ids.join(",")}")
    end

    def find_or_create_organization!(data)
      Organization.create_with(get_organization_attributes(data))
        .find_or_create_by!(identifier: data.dig("organization", "id"))
    end

    def find_or_create_organiser!(data)
      Organiser.create_with(get_organiser_attributes(data))
        .find_or_create_by!(identifier: data.dig("organiser", "id"))
    end

    def find_or_create_event!(data, organization, organiser)
      Event.create_with(get_attributes(data, organization, organiser))
        .find_or_create_by!(identifier: data.dig("id"))
    end

    def get_attributes(data, organization_id, organiser_id)
      {
        organiser_id:,
        organization_id:,
        identifier: data.dig("id")
      }.merge!(data.slice(*column_names))
    end

    def get_organization_attributes(data)
      {
        identifier: data.dig("organization", "id"),
        domain: data.dig("organization", "domain")
      }
    end

    def get_organiser_attributes(data)
      {
        identifier: data.dig("organiser", "id"),
        name: data.dig("organiser", "name")
      }
    end

    def column_names
      @_column_names ||= Event.column_names.without(CUSTOM_ATTRIBUTES)
    end
end
