require 'open-uri'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  
        def google_oauth2
            @user = User.from_omniauth(request.env['omniauth.auth'])
            if @user.persisted?
            flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
            sign_in_and_redirect @user, event: :authentication
            else
            session['devise.google_data'] = request.env['omniauth.auth'].except('extra') 
            redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
        end
     

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
        @user = User.find_by(provider: auth.provider, uid: auth.uid)
        if @user.present?
            sign_in_and_redirect @user, :event => :authentication
            set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
        else
            session["devise.facebook_data"] = request.env["omniauth.auth"]

            @user = User.from_omniauth(request.env["omniauth.auth"])
            filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_fbimage.png'
            file = URI.open(auth.info.image)
            blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename, content_type: file.content_type)
            @user.avatar.attach(blob)
            session[:blob_id] = blob.id
            



=begin
                url = URI.parse(auth[:info][:picture])
                imagename = File.basename(url.path)
                image = URI.open
                @user.avatar.attach(io: image, filename: filename)
=end
            
            render 'devise/registrations/after_social_connection'
            
        end
    end

    def failure
        redirect_to root_path
    end

    
end