class Service < ActiveRecord::Base
    validates :provider_id, presence: true
    belongs_to :provider
    has_many :appointment_services
    has_many :appointments, through: :appointment_services
end