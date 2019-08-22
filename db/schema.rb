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

ActiveRecord::Schema.define(version: 2019_08_22_141014) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "tour_id"
    t.string "file_name"
    t.datetime "taken_date_time"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.integer "elevation_meters"
    t.float "heading"
    t.string "country_code"
    t.text "street_view_url"
    t.text "street_view_thumbnail_url"
    t.string "connection"
    t.float "connection_distance_km"
    t.string "tourer_photo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tourer_version"
    t.index ["tour_id"], name: "index_photos_on_tour_id"
    t.index ["tourer_photo_id", "tour_id"], name: "index_photos_on_tourer_photo_id_and_tour_id", unique: true
    t.index ["tourer_photo_id"], name: "index_photos_on_tourer_photo_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "kind"
    t.index ["kind", "user_id"], name: "index_subscriptions_on_kind_and_user_id", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.bigint "tour_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["tour_id"], name: "index_taggings_on_tour_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tours", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "country_id"
    t.bigint "user_id"
    t.string "google_link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.string "local_id"
    t.integer "tour_type"
    t.index ["country_id"], name: "index_tours_on_country_id"
    t.index ["slug"], name: "index_tours_on_slug", unique: true
    t.index ["user_id", "name"], name: "index_tours_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_tours_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
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
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "api_token"
    t.string "slug"
    t.boolean "terms"
    t.index ["api_token"], name: "index_users_on_api_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
  end

  add_foreign_key "photos", "tours"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "taggings", "tours"
  add_foreign_key "tours", "countries"
  add_foreign_key "tours", "users"
end
