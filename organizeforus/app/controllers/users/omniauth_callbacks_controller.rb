require 'open-uri'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController


        def google_oauth2
            @user = User.find_by(provider: request.env["omniauth.auth"].provider, uid: request.env["omniauth.auth"].uid)
            if @user.present?
                sign_in_and_redirect @user, :event => :authentication
                flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
            else

                auth = request.env["omniauth.auth"]
                @user = User.from_omniauth(auth)
                @user.access_token = auth.credentials.token
                @user.expires_at = auth.credentials.expires_at
                @user.refresh_token = auth.credentials.refresh_token
                session['devise.google_data'] = auth
                session['devise.google_data'].extra.id_token = nil;
              
                
                
  
                render 'devise/registrations/after_social_connection'
        end
    end


    def facebook


        auth = request.env["omniauth.auth"]
        @user = User.find_by(provider: auth.provider, uid: auth.uid)
        if @user.present?
            sign_in_and_redirect @user, :event => :authentication
            set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
        else
            session["devise.facebook_data"] = request.env["omniauth.auth"]

            @user = User.from_omniauth(request.env["omniauth.auth"])
            file = URI.open(auth.info.image)
            filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_fbimage.'+file.content_type.split("/")[1]
            blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename, content_type: file.content_type)
            @user.avatar.attach(blob)
            session[:blob_id] = blob.id            
            render 'devise/registrations/after_social_connection'
        end
    end

    def failure
        redirect_to root_path
    end

    
end