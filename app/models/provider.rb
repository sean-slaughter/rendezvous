class Provider < ActiveRecord::Base
 
    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :business_name, presence: true
    belongs_to :category
    has_many :services
    has_many :appointments
    has_many :clients, through: :appointments

    #return array of providers based on search results 
    def self.search(search)
        self.where('business_name like :q or name like :q', :q => "%#{search}%").to_a
    end

    #used to validate unique email address
    def self.get_emails
        self.all.collect {|provider| provider.email}
    end


    #new appointment requests
    def unconfirmed_appointments
        self.appointments.select{|appointment| appointment.client_request_change == false && appointment.provider_request_change == false && appointment.confirmed == false && appointment.provider_cancelled == false && appointment.client_cancelled == false}
    end

    #existing appointment confirmation/denial
    def unconfirmed_changes
        self.appointments.select{|appointment| appointment.client_request_change == true && appointment.confirmed == false && appointment.client_cancelled == false && appointment.provider_cancelled == false}  
    end

    def new_change_denials
        self.appointments.select{|appointment| appointment.notified == true && appointment.provider_request_change == true && appointment.client_cancelled == true}
    end

    def new_change_confirmations
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.notified == false && appointment.provider_request_change == true}
    end


  

    #cancelled appointments 
    def new_cancellations
        self.appointments.select{|appointment| appointment.client_cancelled == true && appointment.confirmed == true}
    end 

    #used to display old appointment information for change confirmation
    def get_old_appointment(new_appointment)
        self.appointments.find(new_appointment.old_appointment)
     end

    #appointments to show
    def confirmed_appointments
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.client_cancelled == false && appointment.provider_cancelled == false}
    end
end