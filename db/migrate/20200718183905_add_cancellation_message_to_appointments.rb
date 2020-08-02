class AddCancellationMessageToAppointments < ActiveRecord::Migration[4.2]


  def change
    add_column :appointments, :cancellation_message, :string
  end
end
