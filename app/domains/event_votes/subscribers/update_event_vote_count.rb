# frozen_string_literal: true

module EventVotes
  module Subscribers
    class UpdateEventVoteCount
      def call(event)
        case event
        when EventVotes::EventUpvoted, EventVotes::EventDownvoted
          apply_vote_change(event)
        end
      end

      private

        def apply_vote_change(event)
          event_id = event.data[:event_id]
          previous_kind = event.data[:previous_kind]
          new_kind = event.data[:new_kind]
          vote = ::EventVoteCount.find_or_initialize_by(event_id:)
          vote.save! if vote.new_record?

          vote.decrement_count!(previous_kind) if previous_kind.present?
          vote.increment_count!(new_kind) if new_kind.present?
        end
    end
  end
end
