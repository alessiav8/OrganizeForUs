class Group < ApplicationRecord
    #statement che associa un group all'utente che lo crea      
    belongs_to :user
    has_many :members
    has_many :roles
    has_many :partecipations

    scope :list_member, ->(group) {
    arr=Array.new
    arr << 'Select Driver'
    Member.where(group_id: group).each do |member| 
      arr << member.name
    end
    return arr
  }
  scope :list_members, ->(group) {
    Partecipation.where(group_id: group)
  }

  def has_member?
    Member.where(group_id: self.id).count!=0
  end
  def has_driver?
    Member.where(group_id: self.id).where.not(driver: "f").count!=0
  end

  def driver
    if has_driver?
        Member.where(group_id: self.id).where(driver: "t").take.user_email
    end
  end

  validates :name, presence: true
  validates :description, presence: true
    
end
