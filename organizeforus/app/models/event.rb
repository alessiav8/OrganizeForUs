class Event < ApplicationRecord
  belongs_to :group
  belongs_to :user


  has_one :position, dependent: :destroy
  accepts_nested_attributes_for :position, allow_destroy: true


  #h_g=self.group.houres
  has_many :notifications, as: :recipient, dependent: :destroy
  has_noticed_notifications model_name: 'Notification'

  validates :title, presence: true
  validates :description, presence: true
  validates :mode, presence: true
  validates :type_of_hours, presence: true 

  validates :end_date, presence: true,comparison: { greater_than_or_equal_to: :start_date}
  validates :start_date, presence: true


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
