class RemoveCancelledFromAppointments < ActiveRecord::Migration[4.2]

  def change
    change_table :appointments do |t|
      t.remove :cancelled
      t.boolean :client_cancelled
      t.boolean :provider_cancelled
    end
  end
end
