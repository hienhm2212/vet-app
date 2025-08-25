class CreateOwners < ActiveRecord::Migration[8.0]
  def change
    create_table :owners do |t|
      t.string :name, null: false
      t.string :phone, null: false
      t.string :email

      t.timestamps
    end

    add_index :owners, :phone, unique: true
    add_index :owners, :email, unique: true
  end
end
