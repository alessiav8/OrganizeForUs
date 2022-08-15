class Users::AfterAuthController < Devise::OmniauthCallbacksController
    def create



        
       if( session["devise.facebook_data"].present?)
            @user = User.new(user_params)
            @user.provider = session["devise.facebook_data"]["provider"]
            @user.uid = session["devise.facebook_data"]["uid"]
            if (!user_params[:avatar].nil?)
                file = user_params[:avatar]
                filename = filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_Upimage.'+(file.content_type.split("/")[1])
                blob = ActiveStorage::Blob.create_and_upload!(io: user_params[:avatar], filename: filename, content_type: file.content_type)
                @user.avatar.attach(blob)
                session[:blob_id] = blob.id
            elsif (!@user.avatar.attached?)
                @user.avatar.attach(ActiveStorage::Blob.find_by(id: session[:blob_id]))
            end
            if @user.save
                session[:blob_id] = nil
                sign_in_and_redirect @user, :event => :authentication
                set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
                
            else

                render 'devise/registrations/after_social_connection'
            end
        else
                     
                @user = User.new(user_params)

                @user.provider = session["devise.google_data"]["provider"]
                @user.uid = session["devise.google_data"]["uid"]
            
                @user.access_token = session["devise.google_data"]["credentials"]["token"]
                @user.expires_at = session["devise.google_data"]["credentials"]["expires_at"]
                @user.refresh_token = session["devise.google_data"]["credentials"]["refresh_token"] 
          
      
            if (!user_params[:avatar].nil?)
                file = user_params[:avatar]
                filename = filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_Upimage.'+(file.content_type.split("/")[1])
                blob = ActiveStorage::Blob.create_and_upload!(io: user_params[:avatar], filename: filename, content_type: file.content_type)
                @user.avatar.attach(blob)
                session[:blob_id] = blob.id
            elsif (!@user.avatar.attached?)
                @user.avatar.attach(ActiveStorage::Blob.find_by(id: session[:blob_id]))
            end

            if @user.save
                session[:blob_id] = nil
                sign_in_and_redirect @user, :event => :authentication
                set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
            else
                render 'devise/registrations/after_social_connection'
            end
        end
    end
    private
    
    def user_params
        allowed_params = [:name, :surname, :username, :birthday, :email, :password, :password_confirmation]
        allowed_params << :avatar if !(:avatar.nil?)
     
        params.require(:user).permit(allowed_params)
    end
end