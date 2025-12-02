# frozen_string_literal: true

class CreateOrganisers < ActiveRecord::Migration[8.1]
  def change
    create_table :organisers, id: :uuid do |t|
      t.string :identifier, null: false, index: { unique: true }
      t.string :name
      t.timestamps
    end
  end
end
