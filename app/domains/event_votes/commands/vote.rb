# frozen_string_literal: true

module EventVotes
  module Commands
    class Vote
      attr_reader :user_id, :event_id, :vote_kind

      VALID_TYPES = %w[like dislike].freeze

      def initialize(user_id:, event_id:, vote_kind:)
        @user_id = user_id
        @event_id = event_id
        @vote_kind = vote_kind

        validate!
      end

      def validate!
        raise ArgumentError, "user_id is required" if user_id.blank?
        raise ArgumentError, "event_id is required" if event_id.blank?

        unless VALID_TYPES.include?(vote_kind)
          raise ArgumentError, "vote_kind must be 'like' or 'dislike'"
        end
      end
    end
  end
end
