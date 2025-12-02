# frozen_string_literal: true

json.pagination do
  json.current_page @pagy.page
  json.pages @pagy.pages
  json.count @pagy.count
  json.next @pagy.next
  json.prev @pagy.prev
end

json.events @events do |event|
  json.extract! event,
    :id,
    :identifier,
    :title,
    :description,
    :state,
    :availability,
    :event_type,
    :startdate,
    :enddate,
    :url,
    :image_link,
    :region,
    :subregion,
    :macroregion,
    :location,
    :minimum_price,
    :categorization,
    :organization_id,
    :organiser_id,
    :created_at,
    :updated_at

  json.event_vote_count do
    json.partial! "api/v1/events/event_vote_count", event_vote_count: event.event_vote_count
  end
end
