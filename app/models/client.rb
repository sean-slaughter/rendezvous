class Client < ActiveRecord::Base
    
    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    has_many :appointments
    has_many :providers, through: :appointments

    def new_confirmations
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.notified == false && appointment.change_request == false}
    end

    def change_confirmations
        self.appointments.select{|appointment| appointment.confirmed == true && appointment.notified == false && appointment.change_request == true}
    end

end