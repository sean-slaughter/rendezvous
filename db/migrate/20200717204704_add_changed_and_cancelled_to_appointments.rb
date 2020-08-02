class AddChangedAndCancelledToAppointments < ActiveRecord::Migration[4.2]

  def change
    add_column :appointments, :change_request, :boolean
    add_column :appointments, :cancelled, :boolean
  end
end
