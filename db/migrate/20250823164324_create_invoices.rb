class CreateInvoices < ActiveRecord::Migration[8.0]
  def change
    create_table :invoices do |t|
      t.references :appointment, null: false, foreign_key: true
      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0, null: false
      t.string :payment_status, null: false, default: 'pending'

      t.timestamps
    end

    add_index :invoices, :payment_status
  end
end
