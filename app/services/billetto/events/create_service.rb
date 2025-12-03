# frozen_string_literal: true

class Billetto::Events::CreateService
  CUSTOM_ATTRIBUTES = %w[id identifier organiser organization].freeze

  def initialize(data)
    @data = data
  end

  def process!
    unless Event.exists?(identifier:)
      find_or_create_organization!
      find_or_create_organiser!
      create_event!
    end
  end

  private

    attr_reader :data, :organization, :organiser

    def identifier
      data.dig("id")
    end

    def find_or_create_organization!
      @organization = Organization.create_with(organization_attributes)
        .find_or_create_by!(identifier: data.dig("organization", "id"))
    end

    def find_or_create_organiser!
      @organiser = Organiser.create_with(organiser_attributes)
        .find_or_create_by!(identifier: data.dig("organiser", "id"))
    end

    def create_event!
      Event.create!(event_attributes)
    end

    def event_attributes
      {
        organiser_id: organiser.id,
        organization_id: organization.id,
        identifier: data.dig("id")
      }.merge!(data.slice(*column_names))
    end

    def organization_attributes
      {
        identifier: data.dig("organization", "id"),
        domain: data.dig("organization", "domain")
      }
    end

    def organiser_attributes
      {
        identifier: data.dig("organiser", "id"),
        name: data.dig("organiser", "name")
      }
    end

    def column_names
      @_column_names ||= Event.column_names.without(CUSTOM_ATTRIBUTES)
    end
end
