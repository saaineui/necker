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

ActiveRecord::Schema.define(version: 20170908213931) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "cells", force: :cascade do |t|
    t.string "text_val"
    t.bigint "column_id"
    t.bigint "row_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["column_id"], name: "index_cells_on_column_id"
    t.index ["row_id"], name: "index_cells_on_row_id"
  end

  create_table "columns", force: :cascade do |t|
    t.string "name"
    t.bigint "datasheet_id"
    t.boolean "visible"
    t.index ["datasheet_id"], name: "index_columns_on_datasheet_id"
  end

  create_table "datasheets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "rows_count", default: 0
    t.integer "columns_count", default: 0
    t.integer "label_id"
  end

  create_table "rows", force: :cascade do |t|
    t.string "name"
    t.bigint "datasheet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cells_count", default: 0
    t.index ["datasheet_id"], name: "index_rows_on_datasheet_id"
  end

  create_table "words", force: :cascade do |t|
    t.string "name"
    t.string "word"
    t.string "match_exp"
    t.datetime "start_date"
    t.integer "snapshots"
    t.integer "new_york_times"
    t.integer "wall_street_journal"
    t.integer "cnn"
    t.integer "washington_post"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "cells", "columns"
  add_foreign_key "cells", "rows"
  add_foreign_key "columns", "datasheets"
  add_foreign_key "datasheets", "columns", column: "label_id"
  add_foreign_key "rows", "datasheets"
end
