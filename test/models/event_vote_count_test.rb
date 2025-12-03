# frozen_string_literal: true

require "test_helper"

class EventVoteCountTest < ActiveSupport::TestCase
  def setup
    @event_vote_count = create(:event_vote_count)
  end

  def test_event_vote_count_is_invalid_without_event
    @event_vote_count.event = nil
    assert_not @event_vote_count.valid?
    assert_includes @event_vote_count.errors.full_messages,
      "Event must exist"
  end

  def test_event_vote_count_is_invalid_with_negative_likes
    @event_vote_count.likes = -1
    assert_not @event_vote_count.valid?
    assert_includes @event_vote_count.errors.full_messages,
      "Likes must be greater than or equal to 0"
  end

  def test_event_vote_count_is_valid_with_zero_likes
    @event_vote_count.likes = 0
    assert @event_vote_count.valid?
  end

  def test_event_vote_count_is_valid_with_positive_likes
    @event_vote_count.likes = 10
    assert @event_vote_count.valid?
  end

  def test_event_vote_count_is_invalid_with_negative_dislikes
    @event_vote_count.dislikes = -1
    assert_not @event_vote_count.valid?
    assert_includes @event_vote_count.errors.full_messages,
      "Dislikes must be greater than or equal to 0"
  end

  def test_event_vote_count_is_valid_with_zero_dislikes
    @event_vote_count.dislikes = 0
    assert @event_vote_count.valid?
  end

  def test_event_vote_count_is_valid_with_positive_dislikes
    @event_vote_count.dislikes = 10
    assert @event_vote_count.valid?
  end

  def test_increment_count_increments_likes_for_like_kind
    initial_likes = @event_vote_count.likes
    @event_vote_count.increment_count!(:like)
    assert_equal initial_likes + 1, @event_vote_count.reload.likes
  end

  def test_increment_count_increments_dislikes_for_dislike_kind
    initial_dislikes = @event_vote_count.dislikes
    @event_vote_count.increment_count!(:dislike)
    assert_equal initial_dislikes + 1, @event_vote_count.reload.dislikes
  end

  def test_increment_count_does_nothing_for_nil_kind
    initial_likes = @event_vote_count.likes
    initial_dislikes = @event_vote_count.dislikes
    @event_vote_count.increment_count!(nil)
    assert_equal initial_likes, @event_vote_count.reload.likes
    assert_equal initial_dislikes, @event_vote_count.reload.dislikes
  end

  def test_increment_count_does_nothing_for_empty_kind
    initial_likes = @event_vote_count.likes
    initial_dislikes = @event_vote_count.dislikes
    @event_vote_count.increment_count!("")
    assert_equal initial_likes, @event_vote_count.reload.likes
    assert_equal initial_dislikes, @event_vote_count.reload.dislikes
  end

  def test_decrement_count_decrements_likes_for_like_kind
    @event_vote_count.update(likes: 5)
    @event_vote_count.decrement_count!(:like)
    assert_equal 4, @event_vote_count.reload.likes
  end

  def test_decrement_count_decrements_dislikes_for_dislike_kind
    @event_vote_count.update(dislikes: 5)
    @event_vote_count.decrement_count!(:dislike)
    assert_equal 4, @event_vote_count.reload.dislikes
  end

  def test_decrement_count_does_not_decrement_likes_when_zero
    @event_vote_count.update(likes: 0)
    @event_vote_count.decrement_count!(:like)
    assert_equal 0, @event_vote_count.reload.likes
  end

  def test_decrement_count_does_not_decrement_dislikes_when_zero
    @event_vote_count.update(dislikes: 0)
    @event_vote_count.decrement_count!(:dislike)
    assert_equal 0, @event_vote_count.reload.dislikes
  end

  def test_decrement_count_does_nothing_for_nil_kind
    initial_likes = @event_vote_count.likes
    initial_dislikes = @event_vote_count.dislikes
    @event_vote_count.decrement_count!(nil)
    assert_equal initial_likes, @event_vote_count.reload.likes
    assert_equal initial_dislikes, @event_vote_count.reload.dislikes
  end

  def test_decrement_count_does_nothing_for_empty_kind
    initial_likes = @event_vote_count.likes
    initial_dislikes = @event_vote_count.dislikes
    @event_vote_count.decrement_count!("")
    assert_equal initial_likes, @event_vote_count.reload.likes
    assert_equal initial_dislikes, @event_vote_count.reload.dislikes
  end
end
