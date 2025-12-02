# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    identifier { SecureRandom.uuid }
    title { Faker::Lorem.sentence(word_count: 3) }
    url { Faker::Internet.url }
    image_link { Faker::Internet.url }
    availability { [ true, false ].sample }
    state { Event.states.keys.sample }
    association :organization
    association :organiser
  end
end
