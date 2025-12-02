# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[8.1]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :identifier, null: false, index: { unique: true }
      t.string :domain, null: false
      t.timestamps
    end
  end
end
