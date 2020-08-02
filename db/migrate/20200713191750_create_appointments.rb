class CreateAppointments < ActiveRecord::Migration[4.2]

  def change
    create_table :appointments do |t| 
      t.datetime :date
      t.boolean :confirmed
      t.integer :client_id
      t.integer :provider_id
    end
  end
end
