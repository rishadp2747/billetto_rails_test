# frozen_string_literal: true

require "test_helper"

module EventVotes
  class ServiceTest < ActiveSupport::TestCase
    include EventStoreTestHelper

    def setup
      @event = create(:event)
      @user_id = SecureRandom.uuid
      @service = Service.new(event_store: event_store)
    end

    def test_cast_vote_publishes_event_upvoted_when_creating_new_like_vote
      command = build_vote_command(vote_kind: "like")

      assert_difference "EventVote.count", 1 do
        @service.cast_vote(command)
      end

      published_event = assert_vote_event_published(
        EventUpvoted,
        vote_kind: "like",
        previous_kind: nil
      )

      assert_not_nil published_event
      assert_equal @user_id, published_event.data[:user_id]
      assert_equal @event.id, published_event.data[:event_id]
      assert_equal "like", published_event.data[:new_kind]
      assert_nil published_event.data[:previous_kind]
    end

    def test_cast_vote_publishes_event_upvoted_when_creating_new_dislike_vote
      command = build_vote_command(vote_kind: "dislike")

      assert_difference "EventVote.count", 1 do
        @service.cast_vote(command)
      end

      published_event = assert_vote_event_published(
        EventUpvoted,
        vote_kind: "dislike",
        previous_kind: nil
      )

      assert_equal "dislike", published_event.data[:new_kind]
    end

    def test_cast_vote_publishes_event_downvoted_when_changing_vote
      # Create an existing vote
      existing_vote = create(:event_vote, user_id: @user_id, event_id: @event.id, kind: "like")

      command = build_vote_command(vote_kind: "dislike")

      assert_no_difference "EventVote.count" do
        @service.cast_vote(command)
      end

      assert_equal "dislike", existing_vote.reload.kind

      published_event = assert_vote_event_published(
        EventDownvoted,
        vote_kind: "dislike",
        previous_kind: "like"
      )

      assert_not_nil published_event
      assert_equal "like", published_event.data[:previous_kind]
      assert_equal "dislike", published_event.data[:new_kind]
    end

    def test_cast_vote_does_not_publish_event_when_vote_unchanged
      # Create an existing vote
      create(:event_vote, user_id: @user_id, event_id: @event.id, kind: "like")

      command = build_vote_command(vote_kind: "like")

      @service.cast_vote(command)

      assert_no_event_published(EventUpvoted, stream_name: event_stream_name)
      assert_no_event_published(EventDownvoted, stream_name: event_stream_name)
    end

    def test_cast_vote_publishes_to_correct_stream
      command = build_vote_command(vote_kind: "like")

      @service.cast_vote(command)

      stream_events = read_stream_events(event_stream_name)
      assert_equal 1, stream_events.count
      assert_equal EventUpvoted, stream_events.first.class
    end

    def test_multiple_votes_publish_multiple_events_to_same_stream
      user1 = SecureRandom.uuid
      user2 = SecureRandom.uuid

      command1 = build_vote_command(vote_kind: "like", user_id: user1)
      command2 = build_vote_command(vote_kind: "dislike", user_id: user2)

      @service.cast_vote(command1)
      @service.cast_vote(command2)

      stream_events = read_stream_events(event_stream_name)
      assert_equal 2, stream_events.count
      assert_events_published(EventUpvoted, count: 2, stream_name: event_stream_name)
    end

    private

      def build_vote_command(vote_kind:, user_id: nil, event_id: nil)
        Commands::Vote.new(
          user_id: user_id || @user_id,
          event_id: event_id || @event.id,
          vote_kind: vote_kind
        )
      end

      def event_stream_name(event_id = nil)
        "Event$#{event_id || @event.id}"
      end

      def assert_vote_event_published(event_type, vote_kind:, previous_kind: nil, user_id: nil, event_id: nil)
        assert_event_published(
          event_type,
          stream_name: event_stream_name(event_id),
          data: {
            user_id: user_id || @user_id,
            event_id: event_id || @event.id,
            new_kind: vote_kind,
            previous_kind: previous_kind
          }
        )
      end
  end
end

