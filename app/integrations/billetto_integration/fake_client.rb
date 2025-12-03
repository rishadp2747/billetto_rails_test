# frozen_string_literal: true

module BillettoIntegration
  class FakeClient
    def public_events(after: nil, limit: 100)
      if after.present?
        {
          "data" => next_data, "has_more" => false, "next_url" => nil
        }
      else
        {
          "data" => initial_data, "has_more" => true, "next_url" => "https://api.example.com/events?after=123"
        }
      end
    end

    private

      def next_data
        [event_data(id: "125", title: "Event 2", description: "Description 2")]
      end

      def initial_data
        [event_data(id: "123", title: "Event 1", description: "Description 1")]
      end

      def event_data(id:, title:, description:)
        {
          "id" => id,
          "title" => title,
          "description" => description,
          "image_link" => "https://example.com/image.jpg",
          "availability" => true,
          "url" => "https://example.com/event2",
          "state" => "published",
          "organization" => {
            "id" => "124",
            "domain" => "organization2.com"
          },
          "organiser" => {
            "id" => "125",
            "name" => "Organiser 2"
          }
        }
      end
  end
end
