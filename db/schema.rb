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

ActiveRecord::Schema[7.0].define(version: 2023_01_08_124211) do
  create_table "book_requests", force: :cascade do |t|
    t.integer "sent_to_id", null: false
    t.integer "sent_by_id", null: false
    t.integer "sent_for_id", null: false
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sent_by_id"], name: "index_book_requests_on_sent_by_id"
    t.index ["sent_for_id"], name: "index_book_requests_on_sent_for_id"
    t.index ["sent_to_id"], name: "index_book_requests_on_sent_to_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "volumeId"
    t.string "title"
    t.string "subtitle"
    t.string "description"
    t.string "authors"
    t.string "language"
    t.string "pubDate"
    t.string "smallthumbnail"
    t.string "thumbnail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "is_public"
  end

  create_table "friendships", force: :cascade do |t|
    t.integer "sent_by_id", null: false
    t.integer "sent_to_id", null: false
    t.boolean "status", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sent_by_id"], name: "index_friendships_on_sent_by_id"
    t.index ["sent_to_id"], name: "index_friendships_on_sent_to_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "book_requests", "books", column: "sent_for_id"
  add_foreign_key "book_requests", "users", column: "sent_by_id"
  add_foreign_key "book_requests", "users", column: "sent_to_id"
  add_foreign_key "friendships", "users", column: "sent_by_id"
  add_foreign_key "friendships", "users", column: "sent_to_id"
end
