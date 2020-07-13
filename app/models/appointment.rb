class Appointment < ActiveRecord::Base
    validates :date, presence: true
    validates :service, presence: true
    belongs_to :client
    belongs_to :provider
end