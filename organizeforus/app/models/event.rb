class Event < ApplicationRecord
  belongs_to :group
  belongs_to :user

  has_many :partecipations
  accepts_nested_attributes_for :partecipations, allow_destroy: true

  #h_g=self.group.houres


  validates :title, presence: true
  validates :description, presence: true
  #validates :houres, numericality: { greater_than: 0 }
  #validates :houres, numericality: {less_than: h_g}, if: :houre_on_group



  
end
