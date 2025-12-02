# frozen_string_literal: true

FactoryBot.define do
  factory :event_vote do
    kind { EventVote.kinds.keys.sample }
    user_id { SecureRandom.uuid }
    association :event
  end
end
