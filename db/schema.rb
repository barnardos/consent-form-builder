# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171109124132) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "research_sessions", force: :cascade do |t|
    t.string "status", default: "new"
    t.string "methodologies", array: true
    t.string "recording_methods", array: true
    t.string "researcher_name"
    t.string "researcher_phone"
    t.string "researcher_email"
    t.string "researcher_other_name"
    t.boolean "incentives_enabled", default: false
    t.string "payment_type"
    t.decimal "incentive_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "other_methodology"
    t.string "other_recording_method"
    t.boolean "researcher_other"
    t.text "topic"
    t.text "purpose"
    t.string "shared_with"
    t.string "shared_duration"
    t.text "shared_use"
    t.string "duration"
    t.text "participant_equipment"
    t.decimal "travel_expenses_limit"
    t.decimal "food_expenses_limit"
    t.decimal "other_expenses_limit"
    t.boolean "receipts_required", default: true
    t.text "food_provided"
    t.string "location"
    t.string "when_text"
    t.string "name"
    t.string "slug"
    t.boolean "where_when_enabled", default: false
    t.boolean "expenses_enabled", default: false
    t.string "researcher_job_title"
    t.index ["slug"], name: "index_research_sessions_on_slug", unique: true
    t.index ["status"], name: "index_research_sessions_on_status"
  end

end
