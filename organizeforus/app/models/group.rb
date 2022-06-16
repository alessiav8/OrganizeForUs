class Group < ApplicationRecord
    #statement che associa un group all'utente che lo crea      
    belongs_to :user
    has_many :members
    has_many :roles

    scope :list_member, ->(group) {
    arr=Array.new
    arr << 'Select Driver'
    Member.where(group_id: group).each do |member| 
      arr << member.name
    end
    return arr
  }

  def has_member?
    Member.where(group_id: self.id).count!=0
  end
  def has_driver?
    Member.where(group_id: self.id).where.not(driver: nil).take!=nil
  end

  def driver
    Member.where(group_id: self.id).where.not(driver: nil).take.user_email
  end
    
end
