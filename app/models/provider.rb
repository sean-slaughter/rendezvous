class Provider < ActiveRecord::Base
    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    has_many :services
    has_many :appointments
    has_many :clients, through: :appointments

    def unconfirmed_appointments
        self.appointments.select{|appointment| appointment.change_request == false && appointment.confirmed == false && appointment.cancelled == false}
    end

    def changed_appointments
        self.appointments.select{|appointment| appointment.change_request == true && appointment.confirmed == false && appointment.cancelled == false} 
    end

    def cancelled_appointments
        self.appointments.select{|appointment| appointment.cancelled == true && appointment.confirmed == true}
    end 

    def get_old_appointment(new_appointment)
        self.appointments.find do |appointment|
            appointment.provider == new_appointment.provider
            appointment.client == new_appointment.client
            appointment.date == new_appointment.date
            appointment.change_request == false
        end
    end

    def confirmed_appointments
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.cancelled == false}
    end
end