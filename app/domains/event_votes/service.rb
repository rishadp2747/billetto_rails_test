# frozen_string_literal: true

module EventVotes
  class Service
    def initialize(event_store: Rails.configuration.event_store)
      @event_store = event_store
    end

    def cast_vote(command)
      @command = command
      previous_kind = vote&.kind

      if vote.blank?
        create_vote!
        publish_event_upvoted(previous_kind)
      elsif vote_changed?
        update_vote!
        publish_event_downvoted(previous_kind)
      end
    end

    private

      attr_reader :command

      def vote
        @_vote ||= EventVote.find_by(user_id: command.user_id, event_id: command.event_id)
      end

      def create_vote!
        EventVote.create!(user_id: command.user_id, event_id: command.event_id, kind: command.vote_kind)
      end

      def update_vote!
        vote.update!(kind: command.vote_kind)
      end

      def vote_changed?
        vote.kind != command.vote_kind
      end

      def publish_event_upvoted(previous_kind)
        @event_store.publish(EventUpvoted.new(data: data(previous_kind)), stream_name:)
      end

      def publish_event_downvoted(previous_kind)
        @event_store.publish(EventDownvoted.new(data: data(previous_kind)), stream_name:)
      end

      def data(previous_kind)
        {
          user_id: command.user_id,
          event_id: command.event_id,
          new_kind: command.vote_kind,
          previous_kind:
        }
      end

      def stream_name
        "Event$#{command.event_id}"
      end
  end
end
