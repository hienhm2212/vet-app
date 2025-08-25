class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.references :patient, null: false, foreign_key: true
      t.string :veterinarian_name, null: false
      t.datetime :scheduled_at, null: false
      t.string :appointment_type, null: false
      t.string :status, null: false, default: 'scheduled'

      t.timestamps
    end

    add_index :appointments, [ :patient_id, :scheduled_at ]
    add_index :appointments, :scheduled_at
    add_index :appointments, :status
  end
end
