# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    domain { Faker::Internet.domain_name }
    identifier { SecureRandom.uuid }
  end
end
