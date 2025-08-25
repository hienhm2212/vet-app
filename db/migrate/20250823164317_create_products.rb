class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :category, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock, default: 0, null: false
      t.string :supplier
      t.string :barcode, null: false

      t.timestamps
    end

    add_index :products, :barcode, unique: true
    add_index :products, :category
    add_index :products, :supplier
  end
end
