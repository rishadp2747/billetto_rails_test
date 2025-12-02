# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_03_025522) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "categorisations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_store_events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "data", null: false
    t.uuid "event_id", null: false
    t.string "event_type", null: false
    t.jsonb "metadata"
    t.datetime "valid_at"
    t.index ["created_at"], name: "index_event_store_events_on_created_at"
    t.index ["event_id"], name: "index_event_store_events_on_event_id", unique: true
    t.index ["event_type"], name: "index_event_store_events_on_event_type"
    t.index ["valid_at"], name: "index_event_store_events_on_valid_at"
  end

  create_table "event_store_events_in_streams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "event_id", null: false
    t.integer "position"
    t.string "stream", null: false
    t.index ["created_at"], name: "index_event_store_events_in_streams_on_created_at"
    t.index ["event_id"], name: "index_event_store_events_in_streams_on_event_id"
    t.index ["stream", "event_id"], name: "index_event_store_events_in_streams_on_stream_and_event_id", unique: true
    t.index ["stream", "position"], name: "index_event_store_events_in_streams_on_stream_and_position", unique: true
  end

  create_table "event_vote_counts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "dislikes", default: 0, null: false
    t.uuid "event_id", null: false
    t.integer "likes", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_vote_counts_on_event_id"
  end

  create_table "event_votes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "event_id", null: false
    t.string "kind", null: false
    t.datetime "updated_at", null: false
    t.string "user_id", null: false
    t.index ["event_id"], name: "index_event_votes_on_event_id"
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "availability"
    t.jsonb "categorization"
    t.datetime "created_at", null: false
    t.string "description"
    t.datetime "enddate"
    t.string "event_type"
    t.string "identifier", null: false
    t.string "image_link", null: false
    t.jsonb "location"
    t.string "macroregion"
    t.jsonb "minimum_price"
    t.uuid "organiser_id", null: false
    t.uuid "organization_id", null: false
    t.string "region"
    t.datetime "startdate"
    t.string "state", null: false
    t.string "subregion"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["identifier"], name: "index_events_on_identifier", unique: true
    t.index ["organiser_id"], name: "index_events_on_organiser_id"
    t.index ["organization_id"], name: "index_events_on_organization_id"
  end

  create_table "organisers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "identifier", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_organisers_on_identifier", unique: true
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "domain", null: false
    t.string "identifier", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_organizations_on_identifier", unique: true
  end

  create_table "webhook_events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "data"
    t.string "identifier", null: false
    t.string "processing_errors"
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_webhook_events_on_identifier", unique: true
  end

  add_foreign_key "event_store_events_in_streams", "event_store_events", column: "event_id", primary_key: "event_id"
  add_foreign_key "event_vote_counts", "events"
  add_foreign_key "event_votes", "events"
  add_foreign_key "events", "organisers"
  add_foreign_key "events", "organizations"
end
