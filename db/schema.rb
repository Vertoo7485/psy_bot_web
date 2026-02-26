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

ActiveRecord::Schema[7.1].define(version: 2026_02_26_145343) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "anxious_thought_entries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "thought"
    t.integer "probability"
    t.text "facts_pro"
    t.text "facts_con"
    t.text "reframe"
    t.date "entry_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_anxious_thought_entries_on_user_id"
  end

  create_table "days", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.string "title"
    t.text "description"
    t.jsonb "content"
    t.integer "day_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_days_on_program_id"
  end

  create_table "emotion_diary_entries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "date"
    t.text "situation"
    t.text "thoughts"
    t.text "emotions"
    t.text "behavior"
    t.text "evidence_against"
    t.text "new_thoughts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_emotion_diary_entries_on_user_id"
  end

  create_table "gratitude_entries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "entry_date"
    t.text "entry_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_gratitude_entries_on_user_id"
  end

  create_table "grounding_exercise_entries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "entry_date"
    t.text "seen"
    t.text "touched"
    t.text "heard"
    t.text "smelled"
    t.text "tasted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_grounding_exercise_entries_on_user_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reflection_entries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "entry_date"
    t.text "entry_text"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reflection_entries_on_user_id"
  end

  create_table "self_compassion_practices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "entry_date"
    t.text "current_difficulty"
    t.text "common_humanity"
    t.text "kind_words"
    t.text "mantra"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_self_compassion_practices_on_user_id"
  end

  create_table "test_results", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "test_id", null: false
    t.jsonb "answers"
    t.text "interpretation"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "score", default: {}
    t.index ["test_id"], name: "index_test_results_on_test_id"
    t.index ["user_id"], name: "index_test_results_on_user_id"
  end

  create_table "tests", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "category"
    t.jsonb "questions"
    t.jsonb "config"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_day_progresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "day_id", null: false
    t.boolean "completed"
    t.jsonb "answers"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_id"], name: "index_user_day_progresses_on_day_id"
    t.index ["user_id"], name: "index_user_day_progresses_on_user_id"
  end

  create_table "user_programs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "program_id", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer "current_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_user_programs_on_program_id"
    t.index ["user_id"], name: "index_user_programs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_level"
    t.boolean "is_active"
    t.datetime "subscription_ends_at"
    t.datetime "trial_ends_at"
    t.datetime "premium_activated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "anxious_thought_entries", "users"
  add_foreign_key "days", "programs"
  add_foreign_key "emotion_diary_entries", "users"
  add_foreign_key "gratitude_entries", "users"
  add_foreign_key "grounding_exercise_entries", "users"
  add_foreign_key "reflection_entries", "users"
  add_foreign_key "self_compassion_practices", "users"
  add_foreign_key "test_results", "tests"
  add_foreign_key "test_results", "users"
  add_foreign_key "user_day_progresses", "days"
  add_foreign_key "user_day_progresses", "users"
  add_foreign_key "user_programs", "programs"
  add_foreign_key "user_programs", "users"
end
