# frozen_string_literal: true

FactoryBot.define do
  factory :event_vote_counts do
    likes { Faker::Number.between(from: 0, to: 50) }
    dislikes { Faker::Number.between(from: 0, to: 50) }
    association :event
  end
end
