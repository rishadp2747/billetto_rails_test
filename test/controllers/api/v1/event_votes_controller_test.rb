# frozen_string_literal: true

require "test_helper"

module Api
  module V1
    class EventVotesControllerTest < ActionDispatch::IntegrationTest
      def setup
        @event = create(:event)
      end

      def test_create_like_vote
        assert_difference "EventVote.count", 1 do
          post api_v1_event_votes_url, params: payload("like"), headers: valid_headers
        end

        assert_response :ok
        vote = EventVote.last
        assert_equal "like", vote.kind
        assert_equal @event.id, vote.event_id
      end

      def test_create_dislike_vote
        assert_difference "EventVote.count", 1 do
          post api_v1_event_votes_url, params: payload("dislike"), headers: valid_headers
        end

        assert_response :ok
        vote = EventVote.last
        assert_equal "dislike", vote.kind
        assert_equal @event.id, vote.event_id
      end

      def test_invalid_users_cannot_create_votes
        assert_no_difference "EventVote.count" do
          post api_v1_event_votes_url, params: payload
        end

        assert_response :unauthorized
        assert_equal "No token", json_body["error"]
      end

      private

        def payload(vote_kind = "like")
          { event_vote: { event_id: @event.id, vote_kind: } }
        end
    end
  end
end
