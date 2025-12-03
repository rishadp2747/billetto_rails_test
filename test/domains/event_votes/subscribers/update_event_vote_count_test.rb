# frozen_string_literal: true

require "test_helper"

module EventVotes
  module Subscribers
    class UpdateEventVoteCountTest < ActiveSupport::TestCase
      def setup
        @event = create(:event)
        @user_id = SecureRandom.uuid
        @subscriber = UpdateEventVoteCount.new
      end

      def test_call_increments_likes_when_event_upvoted_with_like
        event = build_event_upvoted(new_kind: "like", previous_kind: nil)

        assert_difference -> { EventVoteCount.find_or_initialize_by(event_id: @event.id).likes }, 1 do
          @subscriber.call(event)
        end

        assert_vote_count(likes: 1, dislikes: 0)
      end

      def test_call_increments_dislikes_when_event_upvoted_with_dislike
        event = build_event_upvoted(new_kind: "dislike", previous_kind: nil)

        assert_difference -> { EventVoteCount.find_or_initialize_by(event_id: @event.id).dislikes }, 1 do
          @subscriber.call(event)
        end

        assert_vote_count(likes: 0, dislikes: 1)
      end

      def test_call_decrements_previous_kind_and_increments_new_kind_when_event_downvoted
        setup_vote_count(likes: 5, dislikes: 3)

        event = build_event_downvoted(new_kind: "dislike", previous_kind: "like")

        @subscriber.call(event)

        assert_vote_count(likes: 4, dislikes: 4, message: "Should decrement likes and increment dislikes")
      end

      def test_call_handles_nil_previous_kind
        event = build_event_downvoted(new_kind: "like", previous_kind: nil)

        assert_nothing_raised do
          @subscriber.call(event)
        end

        assert_vote_count(likes: 1, dislikes: 0)
      end

      def test_call_creates_event_vote_count_if_not_exists
        event = build_event_upvoted(new_kind: "like", previous_kind: nil)

        assert_difference "EventVoteCount.count", 1 do
          @subscriber.call(event)
        end
      end

      def test_call_does_not_create_duplicate_event_vote_count
        EventVoteCount.create!(event_id: @event.id, likes: 0, dislikes: 0)

        event = build_event_upvoted(new_kind: "like", previous_kind: nil)

        assert_no_difference "EventVoteCount.count" do
          @subscriber.call(event)
        end
      end

      def test_call_handles_multiple_events_for_same_event
        event1 = build_event_upvoted(user_id: SecureRandom.uuid, new_kind: "like", previous_kind: nil)
        event2 = build_event_upvoted(user_id: SecureRandom.uuid, new_kind: "like", previous_kind: nil)

        @subscriber.call(event1)
        @subscriber.call(event2)

        assert_vote_count(likes: 2, dislikes: 0)
      end

      def test_call_handles_switching_from_like_to_dislike
        setup_vote_count(likes: 10, dislikes: 5)

        event = build_event_downvoted(new_kind: "dislike", previous_kind: "like")

        @subscriber.call(event)

        assert_vote_count(likes: 9, dislikes: 6)
      end

      def test_call_handles_switching_from_dislike_to_like
        setup_vote_count(likes: 10, dislikes: 5)

        event = build_event_downvoted(new_kind: "like", previous_kind: "dislike")

        @subscriber.call(event)

        assert_vote_count(likes: 11, dislikes: 4)
      end

      private

      def build_event_upvoted(user_id: nil, new_kind:, previous_kind:)
        EventUpvoted.new(
          data: {
            user_id: user_id || @user_id,
            event_id: @event.id,
            new_kind: new_kind,
            previous_kind: previous_kind
          }
        )
      end

      def build_event_downvoted(user_id: nil, new_kind:, previous_kind:)
        EventDownvoted.new(
          data: {
            user_id: user_id || @user_id,
            event_id: @event.id,
            new_kind: new_kind,
            previous_kind: previous_kind
          }
        )
      end

      def setup_vote_count(likes:, dislikes:)
        vote_count = EventVoteCount.find_or_initialize_by(event_id: @event.id)
        vote_count.likes = likes
        vote_count.dislikes = dislikes
        vote_count.save!
      end

      def assert_vote_count(likes:, dislikes:, message: nil)
        vote_count = EventVoteCount.find_by(event_id: @event.id)
        assert_not_nil vote_count, message
        assert_equal likes, vote_count.likes, message
        assert_equal dislikes, vote_count.dislikes, message
      end

      def vote_count
        EventVoteCount.find_by(event_id: @event.id)
      end
    end
  end
end

