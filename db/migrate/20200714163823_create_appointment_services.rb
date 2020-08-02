class CreateAppointmentServices < ActiveRecord::Migration[4.2]

  def change
    create_table :appointment_services do |t|
      t.integer :appointment_id
      t.integer :service_id
    end
  end
end
