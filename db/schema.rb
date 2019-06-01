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

ActiveRecord::Schema.define(version: 2019_05_16_163202) do

  create_table "abilities", force: :cascade do |t|
    t.string "ability"
    t.integer "abilities_type_id"
    t.integer "area_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["abilities_type_id"], name: "index_abilities_on_abilities_type_id"
    t.index ["area_id"], name: "index_abilities_on_area_id"
  end

  create_table "abilities_types", force: :cascade do |t|
    t.string "type_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_admins_on_user_id"
  end

  create_table "areas", force: :cascade do |t|
    t.string "area"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_areas_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "collaborators", force: :cascade do |t|
    t.integer "user_id"
    t.integer "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_collaborators_on_state_id"
    t.index ["user_id"], name: "index_collaborators_on_user_id"
  end

  create_table "profile_abilities", force: :cascade do |t|
    t.integer "profile_id"
    t.integer "ability_id"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ability_id"], name: "index_profile_abilities_on_ability_id"
    t.index ["profile_id"], name: "index_profile_abilities_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "profile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "objective"
    t.text "functions"
  end

  create_table "replace_bies", force: :cascade do |t|
    t.integer "to_replace_id"
    t.integer "replacement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["replacement_id"], name: "index_replace_bies_on_replacement_id"
    t.index ["to_replace_id"], name: "index_replace_bies_on_to_replace_id"
  end

  create_table "reports_tos", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "reciever_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reciever_id"], name: "index_reports_tos_on_reciever_id"
    t.index ["sender_id"], name: "index_reports_tos_on_sender_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.integer "rut"
    t.string "password_digest"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
