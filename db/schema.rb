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

ActiveRecord::Schema[8.0].define(version: 2025_08_24_081649) do
  create_table "appointments", force: :cascade do |t|
    t.integer "patient_id", null: false
    t.string "veterinarian_name", null: false
    t.datetime "scheduled_at", null: false
    t.string "appointment_type", null: false
    t.string "status", default: "scheduled", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["patient_id", "scheduled_at"], name: "index_appointments_on_patient_id_and_scheduled_at"
    t.index ["patient_id"], name: "index_appointments_on_patient_id"
    t.index ["scheduled_at"], name: "index_appointments_on_scheduled_at"
    t.index ["status"], name: "index_appointments_on_status"
  end

  create_table "inventory_transactions", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "quantity", null: false
    t.string "transaction_type", null: false
    t.string "source", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "created_at"], name: "index_inventory_transactions_on_product_id_and_created_at"
    t.index ["product_id"], name: "index_inventory_transactions_on_product_id"
    t.index ["transaction_type"], name: "index_inventory_transactions_on_transaction_type"
  end

  create_table "invoice_items", force: :cascade do |t|
    t.integer "invoice_id", null: false
    t.integer "product_id", null: false
    t.integer "quantity", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id", "product_id"], name: "index_invoice_items_on_invoice_id_and_product_id"
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.index ["product_id"], name: "index_invoice_items_on_product_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "appointment_id", null: false
    t.decimal "total_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.string "payment_status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_invoices_on_appointment_id"
    t.index ["payment_status"], name: "index_invoices_on_payment_status"
  end

  create_table "owners", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone", null: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_owners_on_email", unique: true
    t.index ["phone"], name: "index_owners_on_phone", unique: true
  end

  create_table "patients", force: :cascade do |t|
    t.integer "owner_id", null: false
    t.string "name", null: false
    t.string "species", null: false
    t.string "breed"
    t.string "gender", null: false
    t.integer "age"
    t.decimal "weight", precision: 5, scale: 2
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "name"], name: "index_patients_on_owner_id_and_name"
    t.index ["owner_id"], name: "index_patients_on_owner_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "category", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.integer "stock", default: 0, null: false
    t.string "supplier"
    t.string "barcode", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product_type", default: "Cái", null: false
    t.index ["barcode"], name: "index_products_on_barcode", unique: true
    t.index ["category"], name: "index_products_on_category"
    t.index ["supplier"], name: "index_products_on_supplier"
  end

  add_foreign_key "appointments", "patients"
  add_foreign_key "inventory_transactions", "products"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoice_items", "products"
  add_foreign_key "invoices", "appointments"
  add_foreign_key "patients", "owners"
end
