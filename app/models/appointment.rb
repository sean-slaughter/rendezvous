class Appointment < ActiveRecord::Base
    validates :date, presence: true
    belongs_to :client
    belongs_to :provider
    has_many :appointment_services
    has_many :services, through: :appointment_services
end