# frozen_string_literal: true

class Organization < ApplicationRecord
  include Identifiable

  validates :domain, presence: true
end
