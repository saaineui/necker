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

ActiveRecord::Schema.define(version: 20170822001320) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cells", force: :cascade do |t|
    t.string "text_val"
    t.decimal "float_val"
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
    t.boolean "number"
    t.index ["datasheet_id"], name: "index_columns_on_datasheet_id"
  end

  create_table "datasheets", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rows", force: :cascade do |t|
    t.string "name"
    t.bigint "datasheet_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["datasheet_id"], name: "index_rows_on_datasheet_id"
  end

  add_foreign_key "cells", "columns"
  add_foreign_key "cells", "rows"
  add_foreign_key "columns", "datasheets"
  add_foreign_key "rows", "datasheets"
end
