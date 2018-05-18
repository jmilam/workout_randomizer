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

ActiveRecord::Schema.define(version: 20180518151508) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tag", default: 1
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
  end

  create_table "super_sets", force: :cascade do |t|
    t.integer "exercise_one_id"
    t.integer "exercise_two_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_previous_workouts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "workout_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "height", null: false
    t.integer "weight", null: false
    t.string "phone_number"
    t.integer "regularity_id", null: false
    t.integer "goal_id", null: false
    t.string "username", null: false
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workout_details", force: :cascade do |t|
    t.integer "exercise_id"
    t.float "rep_1_weight"
    t.float "rep_2_weight"
    t.float "rep_3_weight"
    t.float "rep_4_weight"
    t.float "rep_5_weight"
    t.float "rep_6_weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "workout_date", default: "05/18/18"
    t.integer "workout_id"
  end

  create_table "workout_groups", force: :cascade do |t|
    t.integer "workout_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "workouts", force: :cascade do |t|
    t.string "name"
    t.integer "frequency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.integer "gym_id"
    t.integer "duration", default: 4
  end

end