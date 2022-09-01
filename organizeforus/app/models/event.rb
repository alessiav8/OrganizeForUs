class Event < ApplicationRecord
  belongs_to :group
  belongs_to :user

  #h_g=self.group.houres


  validates :title, presence: true
  validates :description, presence: true
  #validates :houres, numericality: { greater_than: 0 }
  #validates :houres, numericality: {less_than: h_g}, if: :houre_on_group

  def readonly?
    false
  end
  
  def get_array_members
    members=self.members.remove("[").remove("]").remove('"').remove(' ').split(',')
    array=Array.new
    members.each do |memb|
      array<<User.find_by(email: memb)
    end
    return array
  end

  def email_guest_list
    members=self.members.remove("[").remove("]").remove('"').remove(' ').split(',')
    return members
  end

end
