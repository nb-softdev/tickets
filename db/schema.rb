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

ActiveRecord::Schema.define(version: 20140414174538) do

  create_table "companies", force: true do |t|
    t.string   "name"
    t.string   "business_type"
    t.string   "phone"
    t.string   "mobile"
    t.text     "address"
    t.string   "email"
    t.string   "logo"
    t.string   "url"
    t.string   "sub_domain"
    t.boolean  "is_active",     default: false
    t.boolean  "is_confirmed",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.boolean  "is_feedback", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_templates", force: true do |t|
    t.string   "subject"
    t.text     "content"
    t.string   "email_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "footer_pages", force: true do |t|
    t.string   "name"
    t.string   "page_route"
    t.text     "content"
    t.boolean  "is_footer",  default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.text     "content"
    t.boolean  "is_active",  default: true
    t.boolean  "is_default", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.string   "message"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.string   "name"
    t.text     "body"
    t.integer  "rating"
    t.boolean  "published"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "role_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", force: true do |t|
    t.string   "default_name"
    t.string   "default_label"
    t.string   "default_value"
    t.boolean  "is_active",     default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "user_id"
    t.integer "company_id"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "ticket_logs", force: true do |t|
    t.integer  "ticket_id"
    t.text     "logs"
    t.boolean  "is_deleted", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_notes", force: true do |t|
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_replies", force: true do |t|
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.string   "user_type"
    t.text     "description"
    t.string   "attached_file"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", force: true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.integer  "staff_id"
    t.string   "ticket_secret"
    t.string   "subject"
    t.text     "description"
    t.integer  "priority_id"
    t.integer  "status_id"
    t.string   "attached_file"
    t.boolean  "is_active",     default: true
    t.string   "ticket_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_roles", force: true do |t|
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.string   "time_zone"
    t.integer  "language_id"
    t.string   "interval_time"
    t.string   "image"
    t.date     "birth_date"
    t.integer  "login_count",          default: 0,     null: false
    t.integer  "failed_login_count",   default: 0,     null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "term",                 default: false
    t.boolean  "suspend_notification", default: false
    t.boolean  "is_active",            default: false
    t.string   "registration_key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
