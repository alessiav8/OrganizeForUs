class Partecipation < ApplicationRecord
    belongs_to :user
    belongs_to :group

    @list_role = Array.new

    scope :list_member, ->(group){
        arr=Array.new
        where(group_id: group).each do |member| 
          arr << User.find(member.user_id).email
        end
        return arr
    }

    validates :role, presence: true
    validates :user_id, presence: true
    

    




end
