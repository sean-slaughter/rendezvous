class AddCancellationMessageToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :cancellation_message, :string
  end
end
