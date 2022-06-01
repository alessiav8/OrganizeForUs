module ApplicationHelper
    
    def user_avatar(user, size=50)

        if user.avatar.representable?
            user.avatar.representation(resize_to_limit: [size, size])
        else
            "pikachu.png"
        end
    end
end
