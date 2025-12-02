# frozen_string_literal: true

if event_vote_count.present?
  json.extract! event_vote_count,
    :id,
    :likes,
    :dislikes,
    :event_id
end
