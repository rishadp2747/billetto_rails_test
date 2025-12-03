# frozen_string_literal: true

require "test_helper"

module Api
  module V1
    class EventsControllerTest < ActionDispatch::IntegrationTest
      def test_list_events
        events = create_list(:event, 2)

        get api_v1_events_url, headers: valid_headers
        assert_response :success

        assert_equal events.count, json_body["events"].count
        assert_equal events.map(&:id).sort, json_body["events"].map { |event| event["id"] }.sort
        assert_equal 1, json_body.dig("pagination", "current_page")
      end

      def test_pagination
        create_list(:event, Pagy::DEFAULT[:items] + 1)

        get api_v1_events_url, params: { page: 2 }, headers: valid_headers
        assert_response :success

        assert_equal 1, json_body["events"].size
        assert_equal 2, json_body.dig("pagination", "current_page")
        assert_equal 2, json_body.dig("pagination", "pages")
      end

      def test_valid_users_can_only_see_events
        events = create_list(:event, 2)

        get api_v1_events_url, headers: valid_headers
        assert_response :success
        assert_equal events.count, json_body["events"].count
      end

      def test_invalid_users_cannot_see_events
        get api_v1_events_url
        assert_response :unauthorized
        assert_equal "No token", json_body["error"]
      end
    end
  end
end
