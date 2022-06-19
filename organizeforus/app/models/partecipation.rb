class Partecipation < ApplicationRecord
    belongs_to :user
    belongs_to :group

    @list_role = Array.new
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
