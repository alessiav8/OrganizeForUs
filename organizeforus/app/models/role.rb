class Role < ApplicationRecord
  belongs_to :group

  scope :list_roles, ->(group) {
    arr=Array.new
    arr << 'Select Role'
    where(group_id: group).each do |role| 
      arr << role.tag
    end
    return arr
  }

  before_destroy :update_resources

  def update_resources
    puts "Modify all the people with this role please"
    Member.where(role: self.tag).update(role: nil)
  end 
end
