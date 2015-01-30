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

ActiveRecord::Schema.define(version: 20150130180823) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "auctions", force: true do |t|
    t.string   "title"
    t.boolean  "approved"
    t.text     "description"
    t.integer  "target"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "short_description"
    t.text     "about"
    t.text     "limitations"
    t.datetime "volunteer_end_date"
    t.boolean  "submitted",           default: false
    t.text     "video_description"
    t.text     "videos"
    t.boolean  "featured",            default: false
    t.integer  "display_order"
    t.string   "name"
    t.string   "position"
    t.boolean  "on_donor_page",       default: false
    t.string   "location"
    t.text     "tweet"
    t.integer  "program_id"
    t.boolean  "draft"
    t.string   "sex"
    t.string   "first_name"
  end

  create_table "bids", force: true do |t|
    t.integer  "reward_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "application"
    t.text     "message"
    t.boolean  "premium",     default: false
    t.boolean  "winning",     default: false
  end

  create_table "companies", id: false, force: true do |t|
    t.integer  "id",                            default: 0, null: false
    t.string   "name"
    t.string   "url"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "background_image_file_name"
    t.string   "background_image_content_type"
    t.integer  "background_image_file_size"
    t.datetime "background_image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_domains", force: true do |t|
    t.string   "domain"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hours_entries", force: true do |t|
    t.integer  "amount"
    t.string   "organization"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.string   "contact_position"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "verified",             default: false
    t.integer  "bid_id"
    t.boolean  "user_entered",         default: false
    t.text     "dates"
    t.datetime "verification_sent_at"
  end

  create_table "organizations", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "background_image_file_name"
    t.string   "background_image_content_type"
    t.integer  "background_image_file_size"
    t.datetime "background_image_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "people_descriptor"
    t.boolean  "draft",                         default: true
  end

  create_table "profiles", force: true do |t|
    t.string  "program"
    t.string  "year"
    t.string  "identification_number"
    t.integer "organization_id"
    t.integer "user_id"
    t.string  "department"
    t.string  "location"
    t.boolean "data_privacy"
  end

  create_table "programs", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "eligible_period"
    t.string   "volunteer_opportunities_link"
  end

  create_table "rewards", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "amount"
    t.integer  "max"
    t.integer  "auction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "limit_bidders"
    t.boolean  "premium",       default: false
  end

  create_table "subscribers", force: true do |t|
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.integer  "timezone"
    t.string   "gender"
    t.string   "facebook_image"
    t.string   "username"
    t.boolean  "premium",                default: false
    t.datetime "upgrade_date"
    t.string   "stripe_cus_id"
    t.boolean  "admin",                  default: false, null: false
    t.string   "phone_number"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
