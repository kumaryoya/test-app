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

ActiveRecord::Schema[7.0].define(version: 2026_01_28_061524) do
  create_table "articles", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", null: false
    t.string "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chain_words", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "word", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_chain_words_on_user_id"
  end

  create_table "posts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "race_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "race_id", null: false
    t.integer "boat_number", null: false
    t.string "rank", null: false
    t.integer "flying_count", null: false
    t.integer "late_count", null: false
    t.float "average_st", null: false
    t.float "national_win_rate", null: false
    t.float "national_quinella_rate", null: false
    t.float "national_trio_rate", null: false
    t.float "local_win_rate", null: false
    t.float "local_quinella_rate", null: false
    t.float "local_trio_rate", null: false
    t.float "motor_quinella_rate", null: false
    t.float "motor_trio_rate", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_race_entries_on_race_id"
  end

  create_table "race_results", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "race_id", null: false
    t.integer "rank1_boat", null: false
    t.integer "rank2_boat", null: false
    t.integer "rank3_boat", null: false
    t.integer "rank4_boat", null: false
    t.integer "rank5_boat", null: false
    t.integer "rank6_boat", null: false
    t.integer "trifecta_payout", null: false
    t.integer "trio_payout", null: false
    t.integer "exacta_payout", null: false
    t.integer "quinella_payout", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_race_results_on_race_id"
  end

  create_table "races", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "date", null: false
    t.integer "stadium_id", null: false
    t.integer "race_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "stadium_id", "race_number"], name: "idx_races_on_date_stadium_number", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.integer "age", null: false
    t.string "login_id", null: false
    t.string "encrypted_password", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "spreadsheet_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["login_id"], name: "index_users_on_login_id", unique: true
  end

  add_foreign_key "chain_words", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "race_entries", "races"
  add_foreign_key "race_results", "races"
end
