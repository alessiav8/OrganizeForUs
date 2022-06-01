class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
=begin    
    def facebook
        # You need to implement the method below in your model (e.g. app/models/user.rb)
        @user = User.from_omniauth(request.env["omniauth.auth"])
        if @user.persisted?
            sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
            set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
        else
            session["devise.facebook_data"] = request.env["omniauth.auth"]
            redirect_to new_user_registration_url
        end
    end
=end
    def facebook
        auth = request.env["omniauth.auth"]
        session["devise.facebook_data"] = request.env["omniauth.auth"]
        @user = User.find_by(provider: auth.provider, uid: auth.uid)
        if @user.present?
            sign_in_and_redirect @user, :event => :authentication
            set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
        else
            @user = User.new("name"=>auth.info.name.split(" ")[0], "surname"=>auth.info.name.split(" ")[1], 
                             "email"=>auth.info.email, 
                             "provider"=>auth.provider, "uid"=>auth.uid)
            render 'devise/registrations/after_social_connection'
        end
    end

    def failure
        redirect_to root_path
    end

    
end