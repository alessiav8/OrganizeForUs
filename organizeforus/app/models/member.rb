class Member < ApplicationRecord
  belongs_to :group
  validates :user_email, presence: true, uniqueness: true 

  before_save :check_sub

  def check_sub
    if User.find_by(email: self.user_email)==nil
      self.iscritto= false
    else 
      self.iscritto=true
  end 
  end


end
