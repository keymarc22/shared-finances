# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_29_203534) do
  create_table "budget_users", force: :cascade do |t|
    t.integer "budget_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["budget_id"], name: "index_budget_users_on_budget_id"
    t.index ["user_id"], name: "index_budget_users_on_user_id"
  end

  create_table "budgets", force: :cascade do |t|
    t.string "name", null: false
    t.integer "period", default: 0, null: false
    t.integer "budget_type", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_budgets_on_category_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "category_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expense_splits", force: :cascade do |t|
    t.integer "expense_id", null: false
    t.integer "user_id", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.integer "percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expense_id"], name: "index_expense_splits_on_expense_id"
    t.index ["user_id"], name: "index_expense_splits_on_user_id"
  end

  create_table "money_accounts", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_money_accounts_on_user_id"
  end

  create_table "savings_plans", force: :cascade do |t|
    t.string "name", null: false
    t.integer "target_amount_cents", default: 0, null: false
    t.string "target_amount_currency", default: "USD", null: false
    t.integer "money_account_id", null: false
    t.date "deadline", null: false
    t.integer "status", default: 0, null: false
    t.integer "plan_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["money_account_id"], name: "index_savings_plans_on_money_account_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "description", null: false
    t.integer "transaction_type", default: 0, null: false
    t.boolean "fixed", default: false, null: false
    t.date "transaction_date", null: false
    t.integer "money_account_id", null: false
    t.integer "category_id"
    t.integer "user_id", null: false
    t.string "type", default: "Expense", null: false
    t.integer "savings_plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "USD", null: false
    t.text "comment"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["money_account_id"], name: "index_transactions_on_money_account_id"
    t.index ["savings_plan_id"], name: "index_transactions_on_savings_plan_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "user_savings_plans", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "savings_plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["savings_plan_id"], name: "index_user_savings_plans_on_savings_plan_id"
    t.index ["user_id"], name: "index_user_savings_plans_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "budget_users", "budgets"
  add_foreign_key "budget_users", "users"
  add_foreign_key "expense_splits", "transactions", column: "expense_id"
  add_foreign_key "expense_splits", "users"
  add_foreign_key "money_accounts", "users"
  add_foreign_key "savings_plans", "money_accounts"
  add_foreign_key "transactions", "money_accounts"
  add_foreign_key "transactions", "users"
  add_foreign_key "user_savings_plans", "users"
end
