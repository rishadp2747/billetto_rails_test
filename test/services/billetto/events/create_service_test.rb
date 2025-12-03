# frozen_string_literal: true

require "test_helper"

class Billetto::Events::CreateServiceTest < ActiveSupport::TestCase
  def setup
    @event_data = build_event_data(id: "event-1")
    @service = Billetto::Events::CreateService.new(@event_data)
  end

  def test_process_creates_event_when_not_exists
    assert_difference ["Event.count", "Organization.count", "Organiser.count"], 1 do
      @service.process!
    end

    event = Event.find_by(identifier: "event-1")
    assert_not_nil event
    assert_equal "Test Event", event.title
    assert_equal "https://example.com/event", event.url
  end

  def test_process_does_not_create_event_when_already_exists
    organization = create(:organization, identifier: "org-1", domain: "example.com")
    organiser = create(:organiser, identifier: "org-1", name: "Test Organiser")
    create(:event, identifier: "event-1", organization: organization, organiser: organiser)

    assert_no_difference ["Event.count", "Organization.count", "Organiser.count"] do
      @service.process!
    end
  end

  private

    def build_event_data(id:)
      {
        "id" => id,
        "identifier" => id,
        "title" => "Test Event",
        "url" => "https://example.com/event",
        "image_link" => "https://example.com/image.jpg",
        "availability" => true,
        "state" => "published",
        "organization" => {
          "id" => "org-1",
          "domain" => "example.com"
        },
        "organiser" => {
          "id" => "org-1",
          "name" => "Test Organiser"
        }
      }
    end
end
