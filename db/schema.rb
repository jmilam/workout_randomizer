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

ActiveRecord::Schema.define(version: 20180817121602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blogs", force: :cascade do |t|
    t.string "title"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tag", default: 1
    t.integer "goal_id"
    t.integer "created_by_user_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.binary "example"
    t.text "instructions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "workout_group_id"
    t.boolean "warm_up", default: false
    t.string "warm_up_details", default: ""
    t.string "rep_range", default: ""
    t.integer "set_count", default: 3
    t.integer "super_set_id"
    t.integer "priority"
  end

  create_table "gyms", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.string "phone_number"
    t.string "admin_ids"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_zone", default: "EST"
  end

  create_table "inboxes", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_inboxes_on_user_id"
  end

  create_table "kiosks", force: :cascade do |t|
    t.integer "kiosk_number", null: false
    t.integer "gym_id", null: false
    t.integer "exercise_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kiosk_number", "gym_id", "exercise_id"], name: "by_kiosk_gym_exercise_id"
  end

  create_table "message_groups", force: :cascade do |t|
    t.integer "inbox_id"
    t.string "subject", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.text "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "message_group_id"
    t.integer "user_id"
    t.index ["message_group_id"], name: "index_messages_on_message_group_id"
  end

  create_table "super_sets", force: :cascade do |t|
    t.integer "exercise_one_id"
    t.integer "exercise_two_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_records", id: false, force: :cascade do |t|
    t.string "version", null: false
  end

  create_table "user_previous_workouts", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "workout_group_id"
    t.date "workout_date"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "height", null: false
    t.integer "weight", null: false
    t.string "phone_number"
    t.integer "regularity_id", null: false
    t.integer "goal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "gym_id"
    t.integer "current_workout"
    t.integer "pin"
    t.integer "current_workout_group"
    t.index ["current_workout_group"], name: "index_users_on_current_workout_group"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workout_details", force: :cascade do |t|
    t.integer "exercise_id"
    t.integer "rep_1_weight"
    t.integer "rep_2_weight"
    t.integer "rep_3_weight"
    t.integer "rep_4_weight"
    t.integer "rep_5_weight"
    t.integer "rep_6_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "workout_group_id"
    t.date "workout_date"
    t.integer "user_id"
    t.integer "user_previous_workout_id"
    t.text "comment", default: ""
  end

  create_table "workout_groups", force: :cascade do |t|
    t.integer "workout_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "day"
    t.integer "ab_workout"
  end

  create_table "workouts", force: :cascade do |t|
    t.string "name"
    t.integer "frequency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.integer "gym_id"
    t.integer "duration", default: 4
    t.integer "created_by_user_id"
  end

end
