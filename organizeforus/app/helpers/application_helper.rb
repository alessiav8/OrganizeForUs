module ApplicationHelper
    
    def user_avatar(user, size=50)

        if user.avatar.representable?
            user.avatar.representation(resize_to_limit: [size, size])
        else
            "pikachu.png"
        end
    end

    def group_image(group, size=50)

        if group.image.representable?
            group.image.representation(resize_to_limit: [size, size])
        else
            if group.work?
                "L.png"
            else
                "S.png"
            end

        end
    end

end
