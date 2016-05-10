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

ActiveRecord::Schema.define(version: 20160510195428) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.integer  "user_id",                    null: false
    t.integer  "trail_id",                   null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "sms",        default: false, null: false
    t.boolean  "email",      default: false, null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string   "name",           null: false
    t.integer  "price_in_cents", null: false
    t.string   "stripe_id",      null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id",                                null: false
    t.integer  "plan_id",                                null: false
    t.date     "term_start_date",                        null: false
    t.date     "term_end_date",                          null: false
    t.string   "stripe_customer_id",                     null: false
    t.string   "stripe_subscription_id",                 null: false
    t.boolean  "canceled",               default: false, null: false
    t.text     "card_info",                              null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "trails", force: :cascade do |t|
    t.string   "name",                                                 null: false
    t.string   "slug",                                                 null: false
    t.float    "latitude",                                             null: false
    t.float    "longitude",                                            null: false
    t.string   "source",                                               null: false
    t.string   "display_name"
    t.string   "status"
    t.string   "geojson_url"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.text     "weather_json"
    t.float    "map_center_latitude"
    t.float    "map_center_longitude"
    t.datetime "status_updated_at",    default: '2016-05-10 20:05:23', null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                            default: "",    null: false
    t.string   "encrypted_password",               default: "",    null: false
    t.string   "phone_number"
    t.string   "phone_pin",              limit: 4
    t.boolean  "phone_verified",                   default: false, null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_comped",                        default: false, null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["phone_number"], name: "index_users_on_phone_number", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
