class Client < ActiveRecord::Base
    
    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    has_many :appointments
    has_many :providers, through: :appointments

    def new_confirmations
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.notified == false && appointment.client_change_request == false}
    end

    def change_confirmations
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.notified == false && appointment.client_change_request == true}
    end

    def new_denials
        self.appointments.select{|appointment| appointment.confirmed == false && appointment.client_request_change == false && appointment.cancelled == true}
    end

    def new_change_denials
        self.appointments.select{|appointment| appointment.confirmed == false && appointment.client_request_change == true && appointment.cancelled == true}
    end
    
    def new_request_for_change
        self.appointment.select{|appointment| appointment.confirmed == true && appointment.provider_request_change == true && appointment.notified == false}
    end

    def new_cancellations
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.provider_cancelled == true}
    end

    def confirmed_appointments
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.cancelled == false}
    end
    
    def get_old_appointment(new_appointment)
        self.appointments.find do |appointment|
            appointment.provider == new_appointment.provider
            appointment.client == new_appointment.client
            appointment.date == new_appointment.date
            appointment.client_change_request == false
        end
    end

end