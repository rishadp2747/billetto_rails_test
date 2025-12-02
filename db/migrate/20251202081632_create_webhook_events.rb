# frozen_string_literal: true

class CreateWebhookEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :webhook_events, id: :uuid do |t|
      t.string :identifier, null: false, index: { unique: true }
      t.string :status, null: false, default: "pending"
      t.string :action, null: false
      t.string :processing_errors
      t.jsonb :data
      t.timestamps
    end
  end
end
