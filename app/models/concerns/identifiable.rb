# frozen_string_literal: true

module Identifiable
  extend ActiveSupport::Concern

  included do
    validates :identifier, presence: true, uniqueness: true
  end
end
