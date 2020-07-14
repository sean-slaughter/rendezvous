class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t| 
      t.datetime :date
      t.boolean :confirmed
      t.integer :client_id
      t.integer :provider_id
    end
  end
end
