# frozen_string_literal: true

require "test_helper"

class OrganiserTest < ActiveSupport::TestCase
  def setup
    @organiser = create(:organiser)
  end

  def test_organiser_is_invalid_without_identifier
    @organiser.identifier = ""
    assert_not @organiser.valid?
    assert_includes @organiser.errors.full_messages,
      "Identifier can't be blank"
  end

  def test_organiser_requires_unique_identifier
    @organiser.save!
    duplicate_organiser = build(:organiser, identifier: @organiser.identifier)

    assert_not duplicate_organiser.valid?
    assert_includes duplicate_organiser.errors.full_messages,
      "Identifier has already been taken"
  end
end
