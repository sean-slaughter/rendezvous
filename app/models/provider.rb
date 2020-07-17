class Provider < ActiveRecord::Base
    has_secure_password
    validates :email, presence: true, uniqueness: true
    validates :name, presence: true
    has_many :services
    has_many :appointments
    has_many :clients, through: :appointments

    def unconfirmed_appointments
        unconfirmed_appointments = self.appointments.select{|appointment| appointment.confirmed == false}
    end

    def changed_appointments
        changed_appointments = self.appointments.select{|appointment| appointment.confirmed == true}
    end

    def cancelled_appointments
        cancelled_appointments = self.appointments.select{|appointment| appointment.cancelled == true}
    end 


end