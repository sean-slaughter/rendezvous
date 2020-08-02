class AddOldAppointmentToAppointments < ActiveRecord::Migration[4.2]

  def change
    add_column :appointments, :old_appointment, :integer
  end
end
