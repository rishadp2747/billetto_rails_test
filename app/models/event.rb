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

  validates :title, presence: true
  validates :availability, inclusion: { in: [ true, false ] }

  validates :url, presence: true
  validates :image_link, presence: true
end
