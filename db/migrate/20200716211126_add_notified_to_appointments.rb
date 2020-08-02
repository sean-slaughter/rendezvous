class AddNotifiedToAppointments < ActiveRecord::Migration[4.2]

  def change
    add_column :appointments, :notified, :boolean
  end
end
