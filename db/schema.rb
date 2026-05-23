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

ActiveRecord::Schema[8.1].define(version: 2026_05_20_191007) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.bigint "post_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["post_id"], name: "index_comments_on_post_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "contact_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_contacts_on_user_id"
  end

  create_table "group_conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "group_conversations_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "group_conversation_id"
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "group_messages", force: :cascade do |t|
    t.text "added_new_users"
    t.text "content"
    t.integer "conversation_id"
    t.datetime "created_at", null: false
    t.text "seen_by"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_group_messages_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.text "body"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "private_conversations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "recipient_id"
    t.integer "sender_id"
    t.datetime "updated_at", null: false
  end

  create_table "private_messages", force: :cascade do |t|
    t.text "body"
    t.integer "conversation_id"
    t.datetime "created_at", null: false
    t.boolean "seen"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_private_messages_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "auth_token"
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "provider"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "uid"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "posts"
  add_foreign_key "comments", "users"
  add_foreign_key "contacts", "users"
  add_foreign_key "group_messages", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "private_messages", "users"
end
