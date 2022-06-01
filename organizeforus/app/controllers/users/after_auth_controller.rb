class Users::AfterAuthController < Devise::OmniauthCallbacksController
    def create
        @user = User.new(user_params)
        if @user.save
            sign_in_and_redirect @user, :event => :authentication
            set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
        else
            render 'devise/registrations/after_social_connection'
        end
    end

    private
    
    def user_params
        params.require(:user).permit(:name, :surname, :username, :birthday, :email, :password, :password_confirmation, :provider, :uid)
    end
end