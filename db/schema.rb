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

ActiveRecord::Schema.define(version: 20200716211126) do

  create_table "appointment_services", force: :cascade do |t|
    t.integer "appointment_id"
    t.integer "service_id"
  end

  create_table "appointments", force: :cascade do |t|
    t.datetime "date"
    t.boolean  "confirmed"
    t.integer  "client_id"
    t.integer  "provider_id"
    t.boolean  "notified"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "phone_number"
    t.string "location"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "location"
    t.string "phone_number"
    t.string "business_name"
  end

  create_table "services", force: :cascade do |t|
    t.string  "name"
    t.decimal "price"
    t.integer "provider_id"
    t.string  "description"
  end

end
