# frozen_string_literal: true

FactoryBot.define do
  factory :organiser do
    name { Faker::Name.name }
    identifier { SecureRandom.uuid }
  end
end
