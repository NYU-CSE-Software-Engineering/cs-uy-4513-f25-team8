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

ActiveRecord::Schema[8.1].define(version: 2025_12_07_000000) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "end_date"
    t.integer "item_id", null: false
    t.integer "owner_id", null: false
    t.integer "renter_id", null: false
    t.date "start_date"
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_bookings_on_item_id"
    t.index ["owner_id"], name: "index_bookings_on_owner_id"
    t.index ["renter_id"], name: "index_bookings_on_renter_id"
  end

  create_table "disputes", force: :cascade do |t|
    t.integer "booking_id"
    t.datetime "created_at", null: false
    t.integer "created_by_id", null: false
    t.text "details"
    t.integer "item_id"
    t.string "reason"
    t.text "resolution_notes"
    t.datetime "resolved_at"
    t.integer "resolved_by_id"
    t.string "status", default: "open"
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_disputes_on_booking_id"
    t.index ["created_by_id"], name: "index_disputes_on_created_by_id"
    t.index ["item_id"], name: "index_disputes_on_item_id"
    t.index ["resolved_by_id"], name: "index_disputes_on_resolved_by_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "availability_status", default: "available", null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "owner_id", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_items_on_owner_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "booking_id", null: false
    t.datetime "created_at", null: false
    t.decimal "dollar_amount", precision: 10, scale: 2, null: false
    t.integer "payee_id", null: false
    t.integer "payer_id", null: false
    t.string "payment_method", default: "simulated", null: false
    t.string "payment_type", null: false
    t.string "reference_code"
    t.datetime "settled_at"
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
    t.index ["payee_id"], name: "index_payments_on_payee_id"
    t.index ["payer_id"], name: "index_payments_on_payer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "account_status", default: "active", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "password_digest"
    t.datetime "remember_created_at"
    t.integer "report_count", default: 0, null: false
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role"
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "items"
  add_foreign_key "bookings", "users", column: "owner_id"
  add_foreign_key "bookings", "users", column: "renter_id"
  add_foreign_key "disputes", "bookings"
  add_foreign_key "disputes", "items"
  add_foreign_key "disputes", "users", column: "created_by_id"
  add_foreign_key "disputes", "users", column: "resolved_by_id"
  add_foreign_key "items", "users", column: "owner_id"
  add_foreign_key "payments", "bookings"
  add_foreign_key "payments", "users", column: "payee_id"
  add_foreign_key "payments", "users", column: "payer_id"
end
