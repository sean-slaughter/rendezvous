class Provider < ActiveRecord::Base
    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    has_many :services
    has_many :appointments
    has_many :clients, through: :appointments

    def unconfirmed_appointments
        unconfirmed_appointments = self.appointments.select{|appointment| appointment.change_request == false && appointment.confirmed == false}
    end

    def changed_appointments
        changed_appointments = self.appointments.select{|appointment| appointment.change_request == true}
    end

    def cancelled_appointments
        cancelled_appointments = self.appointments.select{|appointment| appointment.cancelled == true}
    end 

    def get_old_appointment(new_appointment)
        self.appointments.find do |appointment|
            appointment.provider == new_appointment.provider
            appointment.client == new_appointment.client
            appointment.date == new_appointment.date
            appointment.change_request == false
        end
    end
end