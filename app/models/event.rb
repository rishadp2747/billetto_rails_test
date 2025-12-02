# frozen_string_literal: true

class Event < ApplicationRecord
  include Identifiable

  enum :state, {
    draft: "draft",
    published: "published",
    cancelled: "cancelled",
    completed: "completed"
  }, default: :draft, validate: true

  belongs_to :organization
  belongs_to :organiser

  has_one :event_vote_count
  has_many :event_votes, dependent: :destroy_async

  validates :title, presence: true
  validates :url, presence: true
  validates :image_link, presence: true
  validates :availability, inclusion: { in: [ true, false ] }
end
