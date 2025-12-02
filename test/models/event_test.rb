# frozen_string_literal: true

require "test_helper"

class EventTest < ActiveSupport::TestCase
  def setup
    @event = create(:event)
  end

  def test_event_is_invalid_without_identifier
    @event.identifier = ""
    assert_not @event.valid?
    assert_includes @event.errors.full_messages,
      "Identifier can't be blank"
  end

  def test_event_requires_unique_identifier
    @event.save!
    duplicate_event = build(:event, identifier: @event.identifier)

    assert_not duplicate_event.valid?
    assert_includes duplicate_event.errors.full_messages,
      "Identifier has already been taken"
  end

  def test_event_is_invalid_without_title
    @event.title = ""
    assert_not @event.valid?
    assert_includes @event.errors.full_messages,
      "Title can't be blank"
  end

  def test_event_is_invalid_without_url
    @event.url = ""
    assert_not @event.valid?
    assert_includes @event.errors.full_messages,
      "Url can't be blank"
  end

  def test_event_is_invalid_without_image_link
    @event.image_link = ""
    assert_not @event.valid?
    assert_includes @event.errors.full_messages,
      "Image link can't be blank"
  end

  def test_event_is_invalid_with_non_boolean_availability
    @event.availability = nil
    assert_not @event.valid?
    assert_includes @event.errors.full_messages,
      "Availability is not included in the list"
  end

  def test_event_is_invalid_with_unknown_state
    @event.state = "archived"
    assert_not @event.valid?
    assert_includes @event.errors.full_messages,
      "State is not included in the list"
  end
end
