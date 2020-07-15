class Appointment < ActiveRecord::Base
    validates :date, presence: true
    belongs_to :client
    belongs_to :provider
    has_many :appointment_services
    has_many :services, through: :appointment_services

    def total
        output = 0
        self.services.each do |service|
            output += service.price
        end
        output
    end 
end