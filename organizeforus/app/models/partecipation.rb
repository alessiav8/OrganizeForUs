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
=begin
        if @list_role.include?(role)
            true
        else if @list_role.include?(role.upcase)
            true
        else if @list_role.include?(role.downcase)
            true
        else if @list_role.include?(role.upcase_first)
            true
        else 
            false 
        end 
    end

    def add_new_role
        if !check(role) || !check(role.remove(" "))
            @list_role << role
        end 
    end
=end



end
