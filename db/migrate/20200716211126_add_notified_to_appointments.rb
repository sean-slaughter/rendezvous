class AddNotifiedToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :notified, :boolean
  end
end
