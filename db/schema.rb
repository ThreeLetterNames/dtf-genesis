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

ActiveRecord::Schema.define(version: 20161114032305) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contact_people", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
    t.string   "phone"
    t.string   "fax"
    t.string   "email"
  end

  create_table "contract_value_types", force: :cascade do |t|
    t.string   "type_description"
    t.string   "type_shortname"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.string   "vt_contract_number"
    t.string   "vt_title"
    t.date     "vt_start_date"
    t.date     "vt_end_date"
    t.money    "vt_total_value",          scale: 2
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "vt_department_id"
    t.integer  "vt_contract_type_id"
    t.integer  "vt_value_type_id"
    t.integer  "status_index"
    t.integer  "vt_unspc_id"
    t.string   "vt_contract_description"
    t.integer  "vt_supplier_id"
    t.integer  "project_id"
    t.string   "vt_address"
    t.integer  "vt_status_id"
    t.integer  "vt_address_id"
    t.string   "vt_agency_person"
    t.string   "vt_agency_phone"
    t.string   "vt_agency_email"
    t.string   "vt_supplier_name"
    t.string   "vt_supplier_abn"
    t.string   "vt_supplier_acn"
    t.string   "vt_supplier_address"
    t.string   "vt_supplier_email"
  end

  create_table "councils", force: :cascade do |t|
    t.string   "codename"
    t.string   "name"
    t.string   "shortname"
    t.string   "council_type"
    t.string   "region_code"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "cpr_reports", force: :cascade do |t|
    t.integer  "cpr_contract"
    t.integer  "cpr_contractor"
    t.string   "cpr_client"
    t.string   "cpr_principal"
    t.date     "cpr_report_date"
    t.string   "cpr_work_percent_complete"
    t.string   "cpr_report_reason"
    t.money    "cpr_price_as_varied",           scale: 2
    t.money    "cpr_predicted_price",           scale: 2
    t.money    "cpr_actual_price",              scale: 2
    t.integer  "cpr_total_extention_days"
    t.date     "cpr_adjusted_completion_date"
    t.date     "cpr_predicted_completion_date"
    t.date     "cpr_actual_completion_date"
    t.text     "cpr_comments"
    t.integer  "cpr_reporting_officer"
    t.boolean  "cpr_contractor_acknowlages"
    t.integer  "cpr_validating_officer"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.string   "short_name"
    t.integer  "vt_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "location_codes", force: :cascade do |t|
    t.string "code"
    t.string "description"
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "record_no"
    t.integer  "supplier_no"
    t.string   "location_code"
    t.string   "supplier_type"
    t.boolean  "mail_to"
    t.string   "address_line1"
    t.string   "address_line2"
    t.string   "suburb"
    t.integer  "postcode"
    t.string   "po"
    t.string   "po_suburb"
    t.string   "po_postcode"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "mobile"
    t.string   "fax"
    t.string   "email"
    t.string   "website"
    t.string   "title"
    t.string   "firstname"
    t.string   "surname"
    t.date     "updated"
    t.string   "state"
    t.string   "po_state"
    t.boolean  "metro"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "department_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["department_id"], name: "index_projects_on_department_id", using: :btree
  end

  create_table "suppliers", force: :cascade do |t|
    t.string   "name"
    t.string   "abn"
    t.string   "acn"
    t.string   "address"
    t.string   "suburb"
    t.string   "state"
    t.integer  "postcode"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unspscs", force: :cascade do |t|
    t.integer  "unspsc_code"
    t.string   "unspsc_name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "unspsc_alias"
    t.string   "child_category"
    t.string   "parent_category"
  end

  add_foreign_key "projects", "departments"
end
