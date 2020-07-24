class Client < ActiveRecord::Base
   
    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    has_many :appointments
    has_many :providers, through: :appointments

    #used to validate unique email address
    def self.get_emails
        self.all.collect {|client| client.email}
    end

    #new appointment confirmation/denial
    def new_confirmations
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.notified == false && appointment.client_request_change == false && appointment.provider_request_change == false && appointment.provider_cancelled == false}
    end

    def new_denials
        self.appointments.select{|appointment| appointment.confirmed == false && appointment.client_request_change == false && appointment.provider_cancelled == true}
    end

    #existing appointment confirmation/denial
    def new_change_confirmations
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.notified == false && appointment.client_request_change == true}
    end

    def new_change_denials
        self.appointments.select{|appointment| appointment.notified == true && appointment.client_request_change == true && appointment.provider_cancelled == true}
    end
    
    def unconfirmed_changes
        self.appointments.select{|appointment| appointment.confirmed == false && appointment.provider_request_change == true && appointment.notified == false}
    end

    #appointment cancellations
    def new_cancellations
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.provider_cancelled == true && appointment.provider_request_change == false}
    end

    #appointments to display
    def confirmed_appointments
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.provider_cancelled == false && appointment.client_cancelled == false}
    end
    
    #used to compare new and old appointments when asking for change confirmation
    def get_old_appointment(new_appointment)
       self.appointments.find(new_appointment.old_appointment)
    end

end