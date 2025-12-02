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

ActiveRecord::Schema[8.1].define(version: 2025_12_01_142333) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "categorisations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  add_foreign_key "events", "organisers"
  add_foreign_key "events", "organizations"
end
