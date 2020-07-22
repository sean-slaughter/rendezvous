class AddOldAppointmentToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :old_appointment, :integer
  end
end
