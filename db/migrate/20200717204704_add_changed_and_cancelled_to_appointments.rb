class AddChangedAndCancelledToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :changed, :boolean
    add_column :appointments, :cancelled, :boolean
  end
end
