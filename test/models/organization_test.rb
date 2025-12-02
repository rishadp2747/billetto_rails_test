# frozen_string_literal: true

require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  def setup
    @organization = create(:organization)
  end

  def test_organization_is_invalid_without_identifier
    @organization.identifier = ""
    assert_not @organization.valid?
    assert_includes @organization.errors.full_messages,
      "Identifier can't be blank"
  end

  def test_organization_requires_unique_identifier
    @organization.save!
    duplicate_organization = build(:organization, identifier: @organization.identifier)

    assert_not duplicate_organization.valid?
    assert_includes duplicate_organization.errors.full_messages,
      "Identifier has already been taken"
  end

  def test_organization_is_invalid_without_domain
    @organization.domain = ""
    assert_not @organization.valid?
    assert_includes @organization.errors.full_messages,
      "Domain can't be blank"
  end
end
