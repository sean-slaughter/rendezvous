class Provider < ActiveRecord::Base
    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    has_many :services
    has_many :appointments
    has_many :clients, through: :appointments


    #new appointment requests
    def unconfirmed_appointments
        self.appointments.select{|appointment| appointment.client_request_change == false && appointment.confirmed == false && appointment.client_cancelled == false}
    end

    #existing appointment confirmation/denial
    def unconfirmed_changes
        self.appointments.select{|appointment| appointment.client_request_change == true && appointment.confirmed == false && appointment.client_cancelled == false} 
    end

    def change_denials
        self.appointments.select{|appointment| appointment.confirmed == false && appointment.provider_request_change == true && appointment.client_cancelled == true}
    end

    def change_confirmations
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.notified == false && appointment.provider_request_change == true}
    end


  

    #cancelled appointments 
    def cancelled_appointments
        self.appointments.select{|appointment| appointment.client_cancelled == true && appointment.confirmed == true}
    end 

    def get_old_appointment(new_appointment)
        self.appointments.find do |appointment|
            appointment.provider == new_appointment.provider
            appointment.client == new_appointment.client
            appointment.date == new_appointment.date
            appointment.client_request_change == false
        end
    end

    #appointments to show
    def confirmed_appointments
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.client_cancelled == false}
    end
end