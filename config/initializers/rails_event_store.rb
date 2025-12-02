# frozen_string_literal: true

require "ruby_event_store/active_record"
require "ruby_event_store/mappers/default"

Rails.application.config.to_prepare do
  Rails.configuration.event_store = RailsEventStore::JSONClient.new

  Rails.configuration.event_store.subscribe(
    EventVotes::Subscribers::UpdateEventVoteCount,
    to: [
      EventVotes::EventUpvoted,
      EventVotes::EventDownvoted
    ]
  )
end
