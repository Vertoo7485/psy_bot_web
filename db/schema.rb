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

ActiveRecord::Schema[7.1].define(version: 2026_03_09_075537) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "icon"
    t.string "rarity"
    t.jsonb "condition"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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

  create_table "compassion_letters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "entry_date"
    t.text "situation_text"
    t.text "understanding_text"
    t.text "kindness_text"
    t.text "advice_text"
    t.text "closure_text"
    t.text "full_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_compassion_letters_on_user_id"
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

  create_table "experiences", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "total_points"
    t.integer "level"
    t.integer "next_level_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_experiences_on_user_id"
  end

  create_table "fear_conquests", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "conquered_at"
    t.string "category"
    t.string "action"
    t.text "micro_steps"
    t.text "reflection"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_fear_conquests_on_user_id"
  end

  create_table "garden_element_templates", force: :cascade do |t|
    t.string "name"
    t.string "element_type"
    t.string "icon"
    t.string "color"
    t.string "achievement"
    t.jsonb "default_position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "garden_elements", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "element_type"
    t.integer "position_x"
    t.integer "position_y"
    t.datetime "unlocked_at"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "icon"
    t.string "color"
    t.string "achievement"
    t.jsonb "default_position"
    t.index ["user_id"], name: "index_garden_elements_on_user_id"
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

  create_table "kindness_entries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "entry_date"
    t.text "act"
    t.text "reaction"
    t.text "feelings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_kindness_entries_on_user_id"
  end

  create_table "meditation_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "duration_minutes"
    t.string "technique"
    t.integer "rating"
    t.text "notes"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_meditation_sessions_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "amount"
    t.string "currency"
    t.string "status"
    t.string "payment_type"
    t.string "yookassa_id"
    t.string "confirmation_url"
    t.jsonb "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "pleasure_activities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.text "description"
    t.string "activity_type"
    t.integer "duration_minutes"
    t.integer "feelings_before"
    t.integer "feelings_after"
    t.boolean "completed"
    t.datetime "completed_at"
    t.text "reflection"
    t.string "planned_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_pleasure_activities_on_user_id"
  end

  create_table "procrastination_tasks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "entry_date"
    t.text "task"
    t.text "reason"
    t.text "steps"
    t.text "first_step"
    t.text "feelings_after"
    t.boolean "completed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_procrastination_tasks_on_user_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "push_subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "endpoint"
    t.string "p256dh"
    t.string "auth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_push_subscriptions_on_user_id"
  end

  create_table "reconnection_practices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "entry_date"
    t.string "reconnected_person"
    t.string "communication_format"
    t.text "conversation_start"
    t.text "reflection_text"
    t.text "integration_plan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reconnection_practices_on_user_id"
  end

  create_table "reflection_answers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "day_id", null: false
    t.string "question_key"
    t.text "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["day_id"], name: "index_reflection_answers_on_day_id"
    t.index ["user_id"], name: "index_reflection_answers_on_user_id"
  end

  create_table "reflection_entries", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.date "entry_date"
    t.text "entry_text"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reflection_type"
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

  create_table "streaks", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "current_streak"
    t.integer "longest_streak"
    t.datetime "last_activity_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_streaks_on_user_id"
  end

  create_table "support_messages", force: :cascade do |t|
    t.string "name"
    t.text "message"
    t.integer "status"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "user_achievements", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "achievement_id", null: false
    t.datetime "earned_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_id"], name: "index_user_achievements_on_achievement_id"
    t.index ["user_id"], name: "index_user_achievements_on_user_id"
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
  add_foreign_key "compassion_letters", "users"
  add_foreign_key "days", "programs"
  add_foreign_key "emotion_diary_entries", "users"
  add_foreign_key "experiences", "users"
  add_foreign_key "fear_conquests", "users"
  add_foreign_key "garden_elements", "users"
  add_foreign_key "gratitude_entries", "users"
  add_foreign_key "grounding_exercise_entries", "users"
  add_foreign_key "kindness_entries", "users"
  add_foreign_key "meditation_sessions", "users"
  add_foreign_key "payments", "users"
  add_foreign_key "pleasure_activities", "users"
  add_foreign_key "procrastination_tasks", "users"
  add_foreign_key "push_subscriptions", "users"
  add_foreign_key "reconnection_practices", "users"
  add_foreign_key "reflection_answers", "days"
  add_foreign_key "reflection_answers", "users"
  add_foreign_key "reflection_entries", "users"
  add_foreign_key "self_compassion_practices", "users"
  add_foreign_key "streaks", "users"
  add_foreign_key "test_results", "tests"
  add_foreign_key "test_results", "users"
  add_foreign_key "user_achievements", "achievements"
  add_foreign_key "user_achievements", "users"
  add_foreign_key "user_day_progresses", "days"
  add_foreign_key "user_day_progresses", "users"
  add_foreign_key "user_programs", "programs"
  add_foreign_key "user_programs", "users"
end
