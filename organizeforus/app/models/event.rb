class Event < ApplicationRecord
  belongs_to :group
  belongs_to :user

  has_many :partecipations
  accepts_nested_attributes_for :partecipations, allow_destroy: true

  #h_g=self.group.houres


  validate :title



  
end
