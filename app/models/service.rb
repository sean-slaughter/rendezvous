class Service < ActiveRecord::Base
    validates :provider_id, presence: true
    validates :name, presence: true
    validates :description, presence: true
    validates :price, presence: true
    belongs_to :provider
    has_many :appointment_services
    has_many :appointments, through: :appointment_services

    #return array of providers based on search results
    def self.search(search)
        services = self.where('name like :q', :q => "%#{search}%").to_a
        services.collect{|service| service.provider}
    end
    
end




