class Client < ActiveRecord::Base
    
    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    has_many :appointments
    has_many :providers, through: :appointments

    #new appointment confirmation/denial
    def appointment_confirmations
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.notified == false && appointment.client_change_request == false}
    end

    def appointment_denials
        self.appointments.select{|appointment| appointment.confirmed == false && appointment.client_request_change == false && appointment.provider_cancelled == true}
    end

    #existing appointment confirmation/denial
    def change_confirmations
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.notified == false && appointment.client_change_request == true}
    end

    def change_denials
        self.appointments.select{|appointment| appointment.confirmed == false && appointment.client_request_change == true && appointment.cancelled == true}
    end
    
    def unconfirmed_changes
        self.appointment.select{|appointment| appointment.confirmed == false && appointment.provider_request_change == true && appointment.notified == false}
    end

    #appointment cancellations
    def new_cancellations
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.notified == true && appointment.provider_cancelled == true}
    end

    #appointments to display
    def confirmed_appointments
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.provider_cancelled == false && appointment.client_cancelled == false}
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