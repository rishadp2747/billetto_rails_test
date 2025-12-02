# frozen_string_literal: true

class Api::V1::EventVotesController < Api::V1::BaseController
  def create
    command = ::EventVotes::Commands::Vote.new(
      user_id: current_user_id,
      event_id: event_vote_params[:event_id],
      vote_kind: event_vote_params[:vote_kind]
    )
    EventVotes::Service.new.cast_vote(command)
    head :ok
  end

  private

    def event_vote_params
      params.require(:event_vote).permit(:event_id, :vote_kind)
    end
end
