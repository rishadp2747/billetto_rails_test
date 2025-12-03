# frozen_string_literal: true

require "test_helper"

module EventVotes
  # Integration test that verifies the full flow:
  # 1. Service publishes events
  # 2. Subscriber processes events
  # 3. EventVoteCount is updated correctly
  class IntegrationTest < ActiveSupport::TestCase
    include EventStoreTestHelper

    def setup
      @event = create(:event)
      @user_id = SecureRandom.uuid
      @event_store = event_store

      # Subscribe the subscriber to the test event store
      @subscriber = Subscribers::UpdateEventVoteCount.new
      @event_store.subscribe(@subscriber, to: [EventUpvoted, EventDownvoted])

      @service = Service.new(event_store: @event_store)
    end

    def test_full_flow_creates_vote_and_updates_count
      assert_difference "EventVote.count", 1 do
        cast_vote(@user_id, "like")
      end

      # Verify event was published
      assert_event_published(
        EventUpvoted,
        stream_name: event_stream_name
      )

      # Verify subscriber processed the event and updated the count
      assert_vote_count(likes: 1, dislikes: 0)
    end

    def test_full_flow_changes_vote_and_updates_count
      # Create initial vote
      create(:event_vote, user_id: @user_id, event_id: @event.id, kind: "like")
      EventVoteCount.create!(event_id: @event.id, likes: 1, dislikes: 0)

      assert_no_difference "EventVote.count" do
        cast_vote(@user_id, "dislike")
      end

      # Verify EventDownvoted was published
      published_event = assert_event_published(
        EventDownvoted,
        stream_name: event_stream_name
      )

      assert_equal "like", published_event.data[:previous_kind]
      assert_equal "dislike", published_event.data[:new_kind]

      # Verify subscriber processed the event and updated the count
      assert_vote_count(likes: 0, dislikes: 1)
    end

    def test_multiple_users_voting_on_same_event
      user1 = SecureRandom.uuid
      user2 = SecureRandom.uuid
      user3 = SecureRandom.uuid

      # User 1 likes
      cast_vote(user1, "like")

      # User 2 likes
      cast_vote(user2, "like")

      # User 3 dislikes
      cast_vote(user3, "dislike")

      # Verify all events were published
      stream_events = read_stream_events(event_stream_name)
      assert_equal 3, stream_events.count

      # Verify vote count is correct
      assert_vote_count(likes: 2, dislikes: 1)
    end

    def test_user_changes_mind_multiple_times
      # User likes
      cast_vote(@user_id, "like")

      # User changes to dislike
      cast_vote(@user_id, "dislike")

      # User changes back to like
      cast_vote(@user_id, "like")

      # Verify all events were published
      stream_events = read_stream_events(event_stream_name)
      assert_equal 3, stream_events.count

      # Verify vote count reflects final state (1 like, 0 dislikes)
      assert_vote_count(likes: 1, dislikes: 0)
    end

    private

      def vote_command(user_id, vote_kind)
        Commands::Vote.new(
          user_id: user_id,
          event_id: @event.id,
          vote_kind: vote_kind
        )
      end

      def cast_vote(user_id, vote_kind)
        @service.cast_vote(vote_command(user_id, vote_kind))
      end

      def event_stream_name
        "Event$#{@event.id}"
      end

      def vote_count
        EventVoteCount.find_by(event_id: @event.id)
      end

      def assert_vote_count(likes:, dislikes:)
        vote_count_record = vote_count
        assert_not_nil vote_count_record
        assert_equal likes, vote_count_record.likes
        assert_equal dislikes, vote_count_record.dislikes
      end
  end
end

