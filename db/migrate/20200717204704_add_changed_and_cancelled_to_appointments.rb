class AddChangedAndCancelledToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :change_request, :boolean
    add_column :appointments, :cancelled, :boolean
  end
end
