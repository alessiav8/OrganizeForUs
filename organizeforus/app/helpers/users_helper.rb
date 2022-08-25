module UsersHelper
    def full_name
        @user.name + " " + @user.surname
    end

end
