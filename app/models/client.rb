class Client < ActiveRecord::Base
    has_secure_password
    validates :email, presence: true
    validates :name, presence: true
    has_many :appointments
    has_many :providers, through: appointments

end