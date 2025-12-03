# frozen_string_literal: true

require "test_helper"

class EventVoteTest < ActiveSupport::TestCase
  def setup
    @event_vote = create(:event_vote)
  end

  def test_event_vote_is_invalid_without_user_id
    @event_vote.user_id = ""
    assert_not @event_vote.valid?
    assert_includes @event_vote.errors.full_messages,
      "User can't be blank"
  end

  def test_event_vote_is_invalid_without_kind
    @event_vote.kind = nil
    assert_not @event_vote.valid?
    assert_includes @event_vote.errors.full_messages,
      "Kind is not included in the list"
  end

  def test_event_vote_is_valid_with_like_kind
    @event_vote.kind = "like"
    assert @event_vote.valid?
  end

  def test_event_vote_is_valid_with_dislike_kind
    @event_vote.kind = "dislike"
    assert @event_vote.valid?
  end

  def test_event_vote_belongs_to_event
    assert_not_nil @event_vote.event
    assert_instance_of Event, @event_vote.event
  end

  def test_event_vote_is_invalid_without_event
    @event_vote.event = nil
    assert_not @event_vote.valid?
    assert_includes @event_vote.errors.full_messages,
      "Event must exist"
  end
end
