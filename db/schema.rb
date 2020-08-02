# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_31_154448) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "appointment_services", id: :serial, force: :cascade do |t|
    t.integer "appointment_id"
    t.integer "service_id"
  end

  create_table "appointments", id: :serial, force: :cascade do |t|
    t.datetime "date"
    t.boolean "confirmed"
    t.integer "client_id"
    t.integer "provider_id"
    t.boolean "notified"
    t.string "cancellation_message"
    t.boolean "client_cancelled"
    t.boolean "provider_cancelled"
    t.integer "old_appointment"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "phone_number"
    t.string "location"
  end

  create_table "providers", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "location"
    t.string "phone_number"
    t.string "business_name"
    t.integer "category_id"
  end

  create_table "services", id: :serial, force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.integer "provider_id"
    t.string "description"
  end

end
