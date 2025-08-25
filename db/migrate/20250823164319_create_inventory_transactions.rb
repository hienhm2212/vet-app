class CreateInventoryTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :inventory_transactions do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.string :transaction_type, null: false
      t.string :source, null: false

      t.timestamps
    end

    add_index :inventory_transactions, [ :product_id, :created_at ]
    add_index :inventory_transactions, :transaction_type
  end
end
