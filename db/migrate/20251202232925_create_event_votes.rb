class CreateEventVotes < ActiveRecord::Migration[8.1]
  def change
    create_table :event_votes, id: :uuid do |t|
      t.string :kind, null: false
      t.string :user_id, null: false
      t.references :event, null: false, foreign_key: true, type: :uuid
      t.timestamps
    end
  end
end
