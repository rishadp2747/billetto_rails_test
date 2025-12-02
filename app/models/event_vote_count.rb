# frozen_string_literal: true

class EventVoteCount < ApplicationRecord
  validates :event_id, presence: true, uniqueness: true
  validates :likes, numericality: { greater_than_or_equal_to: 0 }
  validates :dislikes, numericality: { greater_than_or_equal_to: 0 }

  def increment_count!(kind)
    return unless kind.present?

    case kind.to_sym
    when :like
      increment!(:likes)
    when :dislike
      increment!(:dislikes)
    end
  end

  def decrement_count!(kind)
    return unless kind.present?

    case kind.to_sym
    when :like
      decrement!(:likes) if likes > 0
    when :dislike
      decrement!(:dislikes) if dislikes > 0
    end
  end
end
