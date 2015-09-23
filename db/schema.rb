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

ActiveRecord::Schema.define(version: 20150923203734) do

  create_table "collects", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "event_id",   limit: 4
    t.integer  "user_id",    limit: 4
  end

  add_index "collects", ["event_id"], name: "index_collects_on_event_id", using: :btree
  add_index "collects", ["user_id"], name: "index_collects_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "content",    limit: 65535
    t.integer  "user_id",    limit: 4
    t.integer  "event_id",   limit: 4
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at",                                                             null: false
    t.datetime "updated_at",                                                             null: false
    t.string   "title",              limit: 255
    t.string   "hoster",             limit: 255
    t.string   "address",            limit: 255
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "contact_phone",      limit: 255
    t.text     "description",        limit: 65535
    t.integer  "price",              limit: 4
    t.integer  "category_cd",        limit: 4
    t.decimal  "latitude",                         precision: 20, scale: 10
    t.decimal  "longitude",                        precision: 20, scale: 10
    t.string   "organizer",          limit: 255
    t.string   "website",            limit: 255
    t.string   "email",              limit: 255
    t.string   "type_cd",            limit: 255
    t.integer  "comments_count",     limit: 4,                               default: 0
    t.integer  "impressions_count",  limit: 4,                               default: 0
    t.integer  "user_id",            limit: 4
    t.decimal  "budget",                           precision: 10
    t.decimal  "showtime",                         precision: 10
    t.string   "cover_file_name",    limit: 255
    t.string   "cover_content_type", limit: 255
    t.integer  "cover_file_size",    limit: 4
    t.datetime "cover_updated_at"
    t.string   "citytalk_price",     limit: 255
  end

  create_table "hosts", force: :cascade do |t|
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "address",     limit: 255
    t.string   "website",     limit: 255
    t.string   "tel",         limit: 255
    t.string   "email",       limit: 255
    t.text     "description", limit: 65535
  end

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type", limit: 255
    t.integer  "impressionable_id",   limit: 4
    t.integer  "user_id",             limit: 4
    t.string   "controller_name",     limit: 255
    t.string   "action_name",         limit: 255
    t.string   "view_name",           limit: 255
    t.string   "request_hash",        limit: 255
    t.string   "ip_address",          limit: 255
    t.string   "session_hash",        limit: 255
    t.text     "message",             limit: 65535
    t.text     "referrer",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: {"impressionable_type"=>nil, "message"=>255, "impressionable_id"=>nil}, using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "phone",           limit: 255
    t.string   "address",         limit: 255
    t.string   "payment_method",  limit: 255
    t.integer  "amount",          limit: 4
    t.integer  "user_id",         limit: 4
    t.string   "payment_status",  limit: 255, default: "pending"
    t.string   "shipping_status", limit: 255, default: "pending"
  end

  create_table "payments", force: :cascade do |t|
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "type",           limit: 255
    t.string   "payment_method", limit: 255
    t.integer  "order_id",       limit: 4
    t.integer  "amount",         limit: 4
    t.boolean  "paid",           limit: 1,     default: false
    t.text     "params",         limit: 65535
  end

  create_table "photos", force: :cascade do |t|
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "user_id",          limit: 4
    t.string   "pic_file_name",    limit: 255
    t.string   "pic_content_type", limit: 255
    t.integer  "pic_file_size",    limit: 4
    t.datetime "pic_updated_at"
  end

  create_table "prices", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "event_id",   limit: 4
    t.decimal  "price",                precision: 10
  end

  create_table "subjects", force: :cascade do |t|
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "title",              limit: 255
    t.string   "link",               limit: 255
    t.string   "address",            limit: 255
    t.decimal  "price",                            precision: 10
    t.string   "end_time",           limit: 255
    t.string   "phone",              limit: 255
    t.string   "email",              limit: 255
    t.text     "description",        limit: 65535
    t.decimal  "budget",                           precision: 10
    t.decimal  "showtime",                         precision: 10
    t.string   "cover_file_name",    limit: 255
    t.string   "cover_content_type", limit: 255
    t.integer  "cover_file_size",    limit: 4
    t.datetime "cover_updated_at"
    t.integer  "user_id",            limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255,                  default: "", null: false
    t.string   "encrypted_password",     limit: 255,                  default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,                    default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
    t.string   "cell_phone",             limit: 255
    t.string   "birthday",               limit: 255
    t.string   "fb_uid",                 limit: 255
    t.string   "fb_token",               limit: 255
    t.string   "image",                  limit: 255
    t.string   "name",                   limit: 255
    t.decimal  "money",                                precision: 10, default: 0
    t.string   "website",                limit: 255
    t.text     "description",            limit: 65535
    t.string   "address",                limit: 255
    t.integer  "bonus",                  limit: 4,                    default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
