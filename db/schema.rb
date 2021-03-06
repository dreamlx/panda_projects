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

ActiveRecord::Schema.define(version: 20151016031405) do

  create_table "billings", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "number",          limit: 255
    t.date     "billing_date"
    t.integer  "person_id",       limit: 4
    t.decimal  "amount",                      precision: 10, scale: 2, default: 0.0
    t.decimal  "outstanding",                 precision: 10, scale: 2, default: 0.0
    t.decimal  "service_billing",             precision: 10, scale: 2, default: 0.0
    t.decimal  "expense_billing",             precision: 10, scale: 2, default: 0.0
    t.integer  "days_of_ageing",  limit: 4,                            default: 0
    t.decimal  "business_tax",                precision: 10, scale: 2, default: 0.0
    t.string   "status",          limit: 255
    t.integer  "collection_days", limit: 4,                            default: 0
    t.integer  "project_id",      limit: 4
    t.integer  "period_id",       limit: 4
    t.decimal  "write_off",                   precision: 10,           default: 0
    t.decimal  "provision",                   precision: 10,           default: 0
    t.integer  "user_id",         limit: 4
  end

  add_index "billings", ["business_tax"], name: "index_billings_on_business_tax", using: :btree
  add_index "billings", ["expense_billing"], name: "index_billings_on_expense_billing", using: :btree
  add_index "billings", ["period_id"], name: "index_billings_on_period_id", using: :btree
  add_index "billings", ["service_billing"], name: "index_billings_on_service_billing", using: :btree

  create_table "bookings", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "project_id", limit: 4
    t.decimal  "hours",                precision: 10, scale: 2, default: 0.0
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
  end

  add_index "bookings", ["project_id"], name: "index_bookings_on_project_id", using: :btree
  add_index "bookings", ["user_id"], name: "index_bookings_on_user_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "chinese_name", limit: 255
    t.string   "english_name", limit: 255
    t.integer  "person_id",    limit: 4
    t.string   "address_1",    limit: 255
    t.string   "person1",      limit: 255
    t.string   "person2",      limit: 255
    t.string   "address_2",    limit: 255
    t.string   "city_1",       limit: 255
    t.string   "city_2",       limit: 255
    t.string   "state_1",      limit: 255
    t.string   "state_2",      limit: 255
    t.string   "country_1",    limit: 255
    t.string   "country_2",    limit: 255
    t.string   "postalcode_1", limit: 255
    t.string   "postalcode_2", limit: 255
    t.string   "title_1",      limit: 255
    t.string   "title_2",      limit: 255
    t.integer  "gender1_id",   limit: 4
    t.integer  "gender2_id",   limit: 4
    t.string   "mobile_1",     limit: 255
    t.string   "mobile_2",     limit: 255
    t.string   "tel_1",        limit: 255
    t.string   "tel_2",        limit: 255
    t.string   "fax_1",        limit: 255
    t.string   "fax_2",        limit: 255
    t.string   "email_1",      limit: 255
    t.string   "email_2",      limit: 255
    t.string   "description",  limit: 255
    t.integer  "category_id",  limit: 4
    t.integer  "status_id",    limit: 4
    t.integer  "region_id",    limit: 4
    t.integer  "industry_id",  limit: 4
    t.string   "client_code",  limit: 255
    t.string   "person3",      limit: 255
    t.string   "title_3",      limit: 255
    t.integer  "gender3_id",   limit: 4
    t.string   "mobile_3",     limit: 255
    t.string   "tel_3",        limit: 255
    t.string   "fax_3",        limit: 255
    t.string   "email_3",      limit: 255
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "user_id",      limit: 4
  end

  create_table "commissions", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "number",     limit: 255
    t.date     "date"
    t.integer  "person_id",  limit: 4
    t.decimal  "amount",                 precision: 10, scale: 2
    t.integer  "project_id", limit: 4
    t.integer  "period_id",  limit: 4
    t.integer  "user_id",    limit: 4
  end

  create_table "common_fees", force: :cascade do |t|
    t.integer  "period_id",  limit: 4
    t.integer  "person_id",  limit: 4
    t.decimal  "common_fee",           precision: 10
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "client_id",  limit: 4
    t.string  "name",       limit: 255
    t.string  "title",      limit: 255
    t.string  "gender",     limit: 255
    t.string  "mobile",     limit: 255
    t.string  "tel",        limit: 255
    t.string  "fax",        limit: 255
    t.string  "email",      limit: 255
    t.string  "address",    limit: 255
    t.string  "city",       limit: 255
    t.string  "state",      limit: 255
    t.string  "country",    limit: 255
    t.string  "postalcode", limit: 255
  end

  create_table "costs", force: :cascade do |t|
    t.decimal  "amount",                     precision: 10, scale: 2
    t.integer  "item_id",        limit: 4
    t.integer  "project_id",     limit: 4
    t.integer  "department_id",  limit: 4
    t.integer  "cost_status_id", limit: 4
    t.string   "description",    limit: 255
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "deductions", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.decimal  "service_PFA",               precision: 10, scale: 2, default: 0.0
    t.decimal  "service_UFA",               precision: 10, scale: 2, default: 0.0
    t.decimal  "service_billing",           precision: 10, scale: 2, default: 0.0
    t.decimal  "expense_PFA",               precision: 10, scale: 2, default: 0.0
    t.decimal  "expense_UFA",               precision: 10, scale: 2, default: 0.0
    t.decimal  "expense_billing",           precision: 10, scale: 2, default: 0.0
    t.integer  "project_id",      limit: 4
  end

  create_table "dicts", force: :cascade do |t|
    t.string "category", limit: 255
    t.string "code",     limit: 255
    t.string "title",    limit: 255
  end

  create_table "expenses", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.decimal  "commission",                     precision: 10, scale: 2, default: 0.0
    t.decimal  "outsourcing",                    precision: 10, scale: 2, default: 0.0
    t.decimal  "tickets",                        precision: 10, scale: 2, default: 0.0
    t.decimal  "courrier",                       precision: 10, scale: 2, default: 0.0
    t.decimal  "postage",                        precision: 10, scale: 2, default: 0.0
    t.decimal  "stationery",                     precision: 10, scale: 2, default: 0.0
    t.decimal  "report_binding",                 precision: 10, scale: 2, default: 0.0
    t.decimal  "cash_advance",                   precision: 10, scale: 2, default: 0.0
    t.integer  "period_id",          limit: 4
    t.integer  "project_id",         limit: 4
    t.decimal  "payment_on_be_half",             precision: 10, scale: 2, default: 0.0
    t.string   "memo",               limit: 255
    t.integer  "user_id",            limit: 4
  end

  add_index "expenses", ["commission"], name: "index_expenses_on_commission", using: :btree
  add_index "expenses", ["courrier"], name: "index_expenses_on_courrier", using: :btree
  add_index "expenses", ["outsourcing"], name: "index_expenses_on_outsourcing", using: :btree
  add_index "expenses", ["payment_on_be_half"], name: "index_expenses_on_payment_on_be_half", using: :btree
  add_index "expenses", ["period_id"], name: "index_expenses_on_period_id", using: :btree
  add_index "expenses", ["postage"], name: "index_expenses_on_postage", using: :btree
  add_index "expenses", ["report_binding"], name: "index_expenses_on_report_binding", using: :btree
  add_index "expenses", ["stationery"], name: "index_expenses_on_stationery", using: :btree
  add_index "expenses", ["tickets"], name: "index_expenses_on_tickets", using: :btree
  add_index "expenses", ["user_id"], name: "index_expenses_on_user_id", using: :btree

  create_table "incomes", force: :cascade do |t|
    t.integer  "item_id",        limit: 4
    t.integer  "project_id",     limit: 4
    t.integer  "department_id",  limit: 4
    t.decimal  "amount",                     precision: 10, scale: 2
    t.integer  "cost_status_id", limit: 4
    t.string   "description",    limit: 255
    t.datetime "created_on"
    t.datetime "updated_on"
  end

  create_table "industries", force: :cascade do |t|
    t.string "code",  limit: 255
    t.string "title", limit: 255
  end

  create_table "initialfees", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.decimal  "service_fee",                  precision: 10, scale: 2, default: 0.0
    t.decimal  "commission",                   precision: 10, scale: 2, default: 0.0
    t.decimal  "outsourcing",                  precision: 10, scale: 2, default: 0.0
    t.decimal  "reimbursement",                precision: 10, scale: 2, default: 0.0
    t.decimal  "meal_allowance",               precision: 10, scale: 2, default: 0.0
    t.decimal  "travel_allowance",             precision: 10, scale: 2, default: 0.0
    t.decimal  "business_tax",                 precision: 10, scale: 2, default: 0.0
    t.decimal  "tickets",                      precision: 10, scale: 2, default: 0.0
    t.decimal  "courrier",                     precision: 10, scale: 2, default: 0.0
    t.decimal  "postage",                      precision: 10, scale: 2, default: 0.0
    t.decimal  "stationery",                   precision: 10, scale: 2, default: 0.0
    t.decimal  "report_binding",               precision: 10, scale: 2, default: 0.0
    t.decimal  "payment_on_be_half",           precision: 10, scale: 2, default: 0.0
    t.integer  "project_id",         limit: 4
    t.decimal  "cash_advance",                 precision: 10, scale: 2, default: 0.0
  end

  create_table "items", force: :cascade do |t|
    t.string "code",      limit: 255
    t.string "titlename", limit: 255
    t.string "img_url",   limit: 255
  end

  create_table "limit_fees", force: :cascade do |t|
    t.integer  "period_id",  limit: 4
    t.integer  "person_id",  limit: 4
    t.decimal  "limit_fee",              precision: 10
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "remark",     limit: 255
  end

  create_table "oursourcings", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "number",     limit: 255
    t.date     "date"
    t.integer  "person_id",  limit: 4
    t.decimal  "amount",                 precision: 10, scale: 2
    t.integer  "project_id", limit: 4
    t.integer  "period_id",  limit: 4
  end

  create_table "overtimes", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "person_id",  limit: 4
    t.date     "ot_date"
    t.decimal  "real_hours",           precision: 10, scale: 2
    t.decimal  "ot_hours",             precision: 10, scale: 2
    t.integer  "ot_type_id", limit: 4
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "chinese_name",      limit: 255
    t.string   "english_name",      limit: 255
    t.string   "employee_number",   limit: 255
    t.integer  "department_id",     limit: 4
    t.string   "grade",             limit: 255
    t.decimal  "charge_rate",                   precision: 10, scale: 2
    t.date     "employeement_date"
    t.string   "address",           limit: 255
    t.string   "postalcode",        limit: 255
    t.string   "mobile",            limit: 255
    t.string   "tel",               limit: 255
    t.string   "extension",         limit: 255
    t.integer  "gender_id",         limit: 4
    t.integer  "status_id",         limit: 4
    t.integer  "GMU_id",            limit: 4
  end

  create_table "periods", force: :cascade do |t|
    t.string   "number",        limit: 255
    t.date     "starting_date"
    t.date     "ending_date"
    t.datetime "created_on"
  end

  create_table "personalcharges", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.decimal  "hours",                          precision: 10, scale: 2, default: 0.0
    t.decimal  "service_fee",                    precision: 10, scale: 2, default: 0.0
    t.decimal  "reimbursement",                  precision: 10, scale: 2, default: 0.0
    t.decimal  "meal_allowance",                 precision: 10, scale: 2, default: 0.0
    t.decimal  "travel_allowance",               precision: 10, scale: 2, default: 0.0
    t.integer  "project_id",         limit: 4
    t.integer  "period_id",          limit: 4
    t.integer  "person_id",          limit: 4
    t.string   "state",              limit: 255
    t.decimal  "PFA_of_service_fee",             precision: 10, scale: 2, default: 0.0
    t.integer  "user_id",            limit: 4
    t.date     "charge_date"
  end

  add_index "personalcharges", ["meal_allowance"], name: "index_personalcharges_on_meal_allowance", using: :btree
  add_index "personalcharges", ["period_id"], name: "index_personalcharges_on_period_id", using: :btree
  add_index "personalcharges", ["reimbursement"], name: "index_personalcharges_on_reimbursement", using: :btree
  add_index "personalcharges", ["service_fee"], name: "index_personalcharges_on_service_fee", using: :btree
  add_index "personalcharges", ["travel_allowance"], name: "index_personalcharges_on_travel_allowance", using: :btree

  create_table "prj_expense_logs", force: :cascade do |t|
    t.integer "prj_id",     limit: 4
    t.integer "expense_id", limit: 4
    t.integer "period_id",  limit: 4
    t.string  "other",      limit: 255
  end

  create_table "projects", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "contract_number",        limit: 255
    t.integer  "client_id",              limit: 4
    t.integer  "GMU_id",                 limit: 4
    t.integer  "service_id",             limit: 4
    t.string   "job_code",               limit: 255
    t.string   "description",            limit: 255
    t.date     "starting_date"
    t.date     "ending_date"
    t.decimal  "estimated_annual_fee",               precision: 10, scale: 2
    t.integer  "risk_id",                limit: 4
    t.integer  "status_id",              limit: 4
    t.integer  "partner_id",             limit: 4
    t.integer  "manager_id",             limit: 4
    t.integer  "referring_id",           limit: 4
    t.integer  "billing_partner_id",     limit: 4
    t.integer  "billing_manager_id",     limit: 4
    t.decimal  "contracted_service_fee",             precision: 10, scale: 2, default: 0.0
    t.decimal  "estimated_commision",                precision: 10, scale: 2, default: 0.0
    t.decimal  "estimated_outsorcing",               precision: 10, scale: 2, default: 0.0
    t.decimal  "budgeted_service_fee",               precision: 10, scale: 2, default: 0.0
    t.integer  "service_PFA",            limit: 4,                            default: 0
    t.integer  "expense_PFA",            limit: 4,                            default: 0
    t.decimal  "contracted_expense",                 precision: 10, scale: 2, default: 0.0
    t.decimal  "budgeted_expense",                   precision: 10, scale: 2, default: 0.0
    t.integer  "PFA_reason_id",          limit: 4
    t.integer  "revenue_id",             limit: 4
  end

  create_table "projects_reports", id: false, force: :cascade do |t|
    t.integer "project_id", limit: 4, null: false
    t.integer "report_id",  limit: 4, null: false
  end

  add_index "projects_reports", ["project_id", "report_id"], name: "index_projects_reports_on_project_id_and_report_id", using: :btree
  add_index "projects_reports", ["report_id", "project_id"], name: "index_projects_reports_on_report_id_and_project_id", using: :btree

  create_table "receive_amounts", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.integer  "billing_id",     limit: 4
    t.string   "invoice_no",     limit: 255
    t.string   "receive_date",   limit: 255
    t.decimal  "receive_amount",             precision: 10, scale: 2, default: 0.0
    t.string   "job_code",       limit: 255
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "period_id",  limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "state",      limit: 255
  end

  add_index "reports", ["period_id"], name: "index_reports_on_period_id", using: :btree
  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "sumselects", force: :cascade do |t|
    t.string  "type",       limit: 255
    t.integer "count_item", limit: 4
  end

  create_table "toupiaos", force: :cascade do |t|
    t.string  "name",   limit: 255
    t.string  "email",  limit: 255
    t.string  "other",  limit: 255
    t.boolean "picked"
    t.string  "other2", limit: 255
    t.string  "other3", limit: 255
    t.string  "other4", limit: 255
  end

  create_table "ufafees", force: :cascade do |t|
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "number",      limit: 255
    t.decimal  "amount",                  precision: 10, scale: 2
    t.integer  "project_id",  limit: 4
    t.integer  "period_id",   limit: 4
    t.decimal  "service_UFA",             precision: 10, scale: 2, default: 0.0
    t.decimal  "expense_UFA",             precision: 10, scale: 2, default: 0.0
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.integer  "person_id",              limit: 4
    t.string   "hashed_password",        limit: 255
    t.boolean  "auth"
    t.string   "other1",                 limit: 255
    t.string   "other2",                 limit: 255
    t.string   "email",                  limit: 255,                          default: "",  null: false
    t.string   "encrypted_password",     limit: 255,                          default: "",  null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,                            default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_on"
    t.datetime "updated_on"
    t.string   "chinese_name",           limit: 255
    t.string   "english_name",           limit: 255
    t.string   "employee_number",        limit: 255
    t.string   "department",             limit: 255
    t.string   "grade",                  limit: 255
    t.decimal  "charge_rate",                        precision: 10, scale: 2, default: 0.0
    t.date     "employeement_date"
    t.string   "address",                limit: 255
    t.string   "postalcode",             limit: 255
    t.string   "mobile",                 limit: 255
    t.string   "tel",                    limit: 255
    t.string   "extension",              limit: 255
    t.string   "gender",                 limit: 255
    t.string   "status",                 limit: 255
    t.string   "GMU",                    limit: 255
    t.string   "role",                   limit: 255
    t.string   "unique_session_id",      limit: 20
  end

  create_table "votes", force: :cascade do |t|
    t.string  "username", limit: 255
    t.string  "email",    limit: 255
    t.string  "picked",   limit: 255
    t.integer "item_id",  limit: 4
  end

  add_foreign_key "bookings", "projects"
  add_foreign_key "bookings", "users"
  add_foreign_key "expenses", "users"
  add_foreign_key "reports", "periods"
  add_foreign_key "reports", "users"
end
