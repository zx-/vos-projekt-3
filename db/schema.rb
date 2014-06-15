# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140615105007) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chat_posts", force: true do |t|
    t.string   "userName"
    t.text     "text"
    t.integer  "room"
    t.datetime "created_at",   default: "now()"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "chat_room_id"
  end

  add_index "chat_posts", ["room"], name: "index_chat_posts_on_room", using: :btree

  create_table "chat_room_web_resources", force: true do |t|
    t.integer  "web_resource_id"
    t.integer  "chat_room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.text     "highlight",       default: ""
  end

  add_index "chat_room_web_resources", ["web_resource_id", "chat_room_id"], name: "unique_res_index", unique: true, using: :btree

  create_table "chat_rooms", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "name"
  end

  create_table "room_rights", force: true do |t|
    t.integer  "user_id",                  null: false
    t.integer  "chat_room_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "level",        default: 0, null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "web_resources", force: true do |t|
    t.text     "url"
    t.integer  "type"
    t.text     "html_original"
    t.text     "html_edited"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "image"
    t.text     "title"
  end

  add_index "web_resources", ["url"], name: "index_web_resources_on_url", using: :btree

end
