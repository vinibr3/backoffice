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

ActiveRecord::Schema.define(version: 2022_06_13_232711) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "zipcode", default: ""
    t.string "street", default: ""
    t.string "number", default: ""
    t.string "complement", default: ""
    t.string "district", default: ""
    t.string "city", default: ""
    t.string "state", default: ""
    t.string "country", default: ""
    t.string "addressable_type"
    t.bigint "addressable_id"
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.integer "gender", limit: 2
    t.string "phone"
    t.string "document"
    t.datetime "birthdate"
    t.boolean "active", default: true
  end

  create_table "api_credentials", force: :cascade do |t|
    t.bigint "user_id"
    t.text "key", default: ""
    t.text "secret", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_api_credentials_on_user_id"
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.string "bank_name"
    t.integer "kind"
    t.string "agency"
    t.string "number"
    t.string "digit"
    t.boolean "active", default: true
    t.bigint "currency_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["currency_id"], name: "index_bank_accounts_on_currency_id"
    t.index ["user_id"], name: "index_bank_accounts_on_user_id"
  end

  create_table "bonus_commissions", force: :cascade do |t|
    t.integer "generation"
    t.float "percentage"
    t.bigint "financial_reason_id"
    t.bigint "product_id"
    t.index ["financial_reason_id"], name: "index_bonus_commissions_on_financial_reason_id"
    t.index ["product_id"], name: "index_bonus_commissions_on_product_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", default: ""
    t.boolean "active", default: true
    t.integer "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_categories_on_code"
  end

  create_table "currencies", force: :cascade do |t|
    t.string "name"
    t.string "initials"
    t.integer "scale", limit: 2
    t.boolean "crypto", default: false
    t.boolean "active", default: true
    t.boolean "order_payment_enabled", default: true
    t.boolean "deposit_payment_enabled", default: true
    t.boolean "withdraw_enabled", default: true
    t.boolean "receivable_method_enabled", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "symbol"
  end

  create_table "deposit_parametrizations", force: :cascade do |t|
    t.bigint "minimum_amount"
    t.bigint "maximum_amount"
    t.bigint "currency_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["currency_id"], name: "index_deposit_parametrizations_on_currency_id"
  end

  create_table "deposits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "amount"
    t.bigint "currency_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["currency_id"], name: "index_deposits_on_currency_id"
    t.index ["user_id"], name: "index_deposits_on_user_id"
  end

  create_table "financial_reasons", force: :cascade do |t|
    t.string "title"
    t.integer "code"
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "chargebackable_by_inactivity", default: true
    t.index ["code"], name: "index_financial_reasons_on_code"
  end

  create_table "financial_transactions", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "spreader_user_id"
    t.bigint "order_id"
    t.bigint "financial_reason_id"
    t.bigint "currency_id"
    t.bigint "bonus_commission_id"
    t.text "note"
    t.bigint "user_amount", default: 0
    t.bigint "admin_amount", default: 0
    t.bigint "system_amount", default: 0
    t.integer "admin_cashflow"
    t.integer "system_cashflow", default: 0
    t.integer "user_cashflow"
    t.integer "financial_result_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "withdraw_id"
    t.integer "product_id"
    t.bigint "chargebacker_by_inactivity_id"
    t.bigint "deposit_id"
    t.index ["bonus_commission_id"], name: "index_financial_transactions_on_bonus_commission_id"
    t.index ["chargebacker_by_inactivity_id"], name: "index_financial_transactions_on_chargebacker_by_inactivity_id"
    t.index ["currency_id"], name: "index_financial_transactions_on_currency_id"
    t.index ["deposit_id"], name: "index_financial_transactions_on_deposit_id"
    t.index ["financial_reason_id"], name: "index_financial_transactions_on_financial_reason_id"
    t.index ["financial_result_code"], name: "index_financial_transactions_on_financial_result_code"
    t.index ["order_id"], name: "index_financial_transactions_on_order_id"
    t.index ["product_id"], name: "index_financial_transactions_on_product_id"
    t.index ["spreader_user_id"], name: "index_financial_transactions_on_spreader_user_id"
    t.index ["user_id"], name: "index_financial_transactions_on_user_id"
    t.index ["withdraw_id"], name: "index_financial_transactions_on_withdraw_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "product_id"
    t.integer "quantity"
    t.bigint "unit_price"
    t.bigint "total_price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_items_on_order_id"
    t.index ["product_id"], name: "index_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "subtotal"
    t.bigint "total"
    t.datetime "expire_at"
    t.bigint "currency_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["currency_id"], name: "index_orders_on_currency_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.bigint "currency_id"
    t.boolean "active", default: true
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["currency_id"], name: "index_payment_methods_on_currency_id"
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.string "payable_type"
    t.bigint "payable_id"
    t.bigint "payment_method_id"
    t.integer "status", limit: 2
    t.string "transaction_code"
    t.bigint "amount"
    t.jsonb "creation_response"
    t.datetime "paid_at"
    t.jsonb "notification_response"
    t.text "digital_address", default: ""
    t.text "qr_code_base64", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payable_type", "payable_id"], name: "index_payment_transactions_on_payable_type_and_payable_id"
    t.index ["payment_method_id"], name: "index_payment_transactions_on_payment_method_id"
    t.index ["transaction_code"], name: "index_payment_transactions_on_transaction_code"
  end

  create_table "pixes", force: :cascade do |t|
    t.string "secret_key"
    t.integer "kind"
    t.boolean "active", default: true
    t.bigint "currency_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["currency_id"], name: "index_pixes_on_currency_id"
    t.index ["user_id"], name: "index_pixes_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "profile_id"
    t.bigint "category_id"
    t.bigint "price"
    t.string "name", default: ""
    t.text "description", default: ""
    t.boolean "active", default: true
    t.integer "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["code"], name: "index_products_on_code"
    t.index ["profile_id"], name: "index_products_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.float "trade_fee_percentage"
    t.integer "duration_days_per_purchase"
    t.integer "duration_days_per_monthly_result"
    t.integer "monthly_qualification_amount"
    t.boolean "active", default: true
  end

  create_table "rule_ruleables", force: :cascade do |t|
    t.bigint "rule_id"
    t.string "ruleable_type"
    t.bigint "ruleable_id"
    t.bigint "inactivator_id"
    t.datetime "inactive_at"
    t.index ["inactivator_id"], name: "index_rule_ruleables_on_inactivator_id"
    t.index ["rule_id"], name: "index_rule_ruleables_on_rule_id"
    t.index ["ruleable_type", "ruleable_id"], name: "index_rule_ruleables_on_ruleable_type_and_ruleable_id"
  end

  create_table "rules", force: :cascade do |t|
    t.integer "code"
    t.text "description"
    t.string "name"
  end

  create_table "system_parametrizations", force: :cascade do |t|
    t.string "registration_attribute", default: "email"
    t.text "sign_in_attributes"
    t.boolean "user_confirmable_on_register", default: false
    t.boolean "user_confirmed_for_withdraw_mandatory", default: true
    t.boolean "mandatory_register_with_sponsor_token"
    t.boolean "pay_direct_indication_bonus", default: true
    t.boolean "pay_indirect_indication_bonus", default: true
    t.boolean "pay_residual_bonus", default: true
    t.boolean "compliance_on_withdrawal_mandatory", default: true
    t.text "current_withdraw_parametrization_ids"
    t.text "current_deposit_parametrization_ids"
    t.integer "seconds_to_expire_session", default: 300
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "seconds_to_expire_reset_password_token", default: 300
    t.integer "seconds_to_expire_confirmation_token", default: 300
    t.integer "maximum_generation_range_to_query_unilevel_nodes", limit: 2, default: 5
    t.boolean "mandatory_withdraw_confirmation_by_email", default: true
  end

  create_table "unilevel_nodes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "sponsored_id", null: false
    t.text "ancestry"
    t.integer "ancestry_depth", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ancestry"], name: "index_unilevel_nodes_on_ancestry"
    t.index ["sponsored_id"], name: "index_unilevel_nodes_on_sponsored_id"
    t.index ["user_id"], name: "index_unilevel_nodes_on_user_id"
  end

  create_table "user_profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "profile_id"
    t.datetime "expire_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_user_profiles_on_profile_id"
    t.index ["user_id"], name: "index_user_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "password_digest", null: false
    t.datetime "terms_of_service_accepted_at"
    t.inet "terms_of_service_accepted_ip"
    t.string "name", default: ""
    t.string "nickname", default: ""
    t.integer "gender", limit: 2
    t.string "document", default: ""
    t.date "birthdate"
    t.datetime "active_until_at"
    t.string "cellphone", default: ""
    t.string "facebook", default: ""
    t.string "instagram", default: ""
    t.string "twitter", default: ""
    t.string "sponsor_token", default: ""
    t.datetime "sent_to_compliance_at"
    t.datetime "compliance_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "provider", default: "", null: false
    t.string "uid", default: ""
    t.string "reset_password_token", default: ""
    t.datetime "reset_password_token_sent_at"
    t.string "confirmation_token", default: ""
    t.datetime "confirmed_at"
    t.datetime "confirmation_token_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "compliance_admin_user_id"
    t.bigint "profile_id"
    t.index ["cellphone"], name: "index_users_on_cellphone"
    t.index ["compliance_admin_user_id"], name: "index_users_on_compliance_admin_user_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token"
    t.index ["document"], name: "index_users_on_document"
    t.index ["email"], name: "index_users_on_email"
    t.index ["nickname"], name: "index_users_on_nickname"
    t.index ["profile_id"], name: "index_users_on_profile_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
    t.index ["sponsor_token"], name: "index_users_on_sponsor_token"
    t.index ["uid"], name: "index_users_on_uid"
  end

  create_table "wallets", force: :cascade do |t|
    t.string "secret_hash"
    t.boolean "active", default: true
    t.bigint "currency_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["currency_id"], name: "index_wallets_on_currency_id"
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  create_table "withdraw_parametrizations", force: :cascade do |t|
    t.bigint "minimum_amount"
    t.bigint "maximum_amount"
    t.bigint "currency_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["currency_id"], name: "index_withdraw_parametrizations_on_currency_id"
  end

  create_table "withdraws", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "updater_admin_user_id"
    t.bigint "currency_id"
    t.string "receivable_method_type"
    t.bigint "receivable_method_id"
    t.bigint "gross_amount"
    t.bigint "net_amount"
    t.bigint "fee"
    t.bigint "receivable_currency_amount"
    t.integer "status"
    t.datetime "status_update_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "confirmation_token", default: ""
    t.index ["confirmation_token"], name: "index_withdraws_on_confirmation_token"
    t.index ["currency_id"], name: "index_withdraws_on_currency_id"
    t.index ["receivable_method_type", "receivable_method_id"], name: "index_receivable_method"
    t.index ["updater_admin_user_id"], name: "index_withdraws_on_updater_admin_user_id"
    t.index ["user_id"], name: "index_withdraws_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bank_accounts", "users"
  add_foreign_key "financial_transactions", "deposits"
  add_foreign_key "financial_transactions", "financial_transactions", column: "chargebacker_by_inactivity_id"
  add_foreign_key "financial_transactions", "products"
  add_foreign_key "pixes", "users"
  add_foreign_key "unilevel_nodes", "users"
  add_foreign_key "unilevel_nodes", "users", column: "sponsored_id"
  add_foreign_key "users", "profiles"
end
