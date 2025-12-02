# frozen_string_literal: true

require "pagy"
require "pagy/extras/array"
require "pagy/extras/overflow"

Pagy::DEFAULT[:items] = 20
Pagy::DEFAULT[:overflow] = :empty_page
Pagy::DEFAULT[:items_param] = :page_size
