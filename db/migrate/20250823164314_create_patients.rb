class CreatePatients < ActiveRecord::Migration[8.0]
  def change
    create_table :patients do |t|
      t.references :owner, null: false, foreign_key: true
      t.string :name, null: false
      t.string :species, null: false
      t.string :breed
      t.string :gender, null: false
      t.integer :age
      t.decimal :weight, precision: 5, scale: 2
      t.text :notes

      t.timestamps
    end

    add_index :patients, [:owner_id, :name]
  end
end
