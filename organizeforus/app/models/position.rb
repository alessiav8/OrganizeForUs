class Position < ApplicationRecord
    
    geocoded_by :address
    after_validation :geocode 
    belongs_to :event

    def address
        [street, city, province, country].compact.join(', ')
    end

    validates :city, presence: true
    validates :street, presence: true
    validates :province, presence: true
    validates :country, presence: true

end
