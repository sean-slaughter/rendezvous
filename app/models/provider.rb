class Provider < ActiveRecord::Base
    has_secure_password
    validates :email, presence: true
    validates :name, presence: true
    has_many :services
    has_many :appointments
    has_many :clients, through: :appointments
end