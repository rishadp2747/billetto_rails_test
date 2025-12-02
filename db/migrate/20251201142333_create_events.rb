# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :events, id: :uuid do |t|
      t.string :identifier, null: false, index: { unique: true }
      t.string :title, null: false
      t.string :state, null: false
      t.string :url, null: false
      t.string :image_link, null: false
      t.string :macroregion
      t.string :subregion
      t.string :region
      t.string :event_type
      t.string :description
      t.boolean :availability
      t.jsonb :minimum_price
      t.jsonb :location
      t.jsonb :categorization
      t.datetime :startdate
      t.datetime :enddate
      t.references :organization, null: false, foreign_key: true, type: :uuid
      t.references :organiser, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
