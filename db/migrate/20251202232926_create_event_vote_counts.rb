# frozen_string_literal: true

class CreateEventVoteCounts < ActiveRecord::Migration[8.1]
  def change
    create_table :event_vote_counts, id: :uuid do |t|
      t.integer :likes, default: 0, null: false
      t.integer :dislikes, default: 0, null: false
      t.references :event, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
