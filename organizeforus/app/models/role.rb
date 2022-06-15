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
end
