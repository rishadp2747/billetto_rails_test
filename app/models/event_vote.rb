# frozen_string_literal: true

class EventVote < ApplicationRecord
  enum :kind, {
    like: "like",
    dislike: "dislike"
  }, validate: true

  belongs_to :event

  validates :user_id, presence: true, uniqueness: { scope: :event_id }
end
