require 'open-uri'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :set_cache_headers
    
    def google_oauth2
        @user = User.find_by(provider: request.env["omniauth.auth"].provider, uid: request.env["omniauth.auth"].uid)
        if @user.present?
            sign_in_and_redirect @user, :event => :authentication
            flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        else

            auth = request.env["omniauth.auth"]
            @user = User.from_omniauth(auth)
            file = URI.open(auth.info.image)
            filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_gglimage.'+file.content_type.split("/")[1]
            blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename, content_type: file.content_type)
            @user.avatar.attach(blob)
            session[:blob_id] = blob.id
            @user.access_token = auth.credentials.token
            @user.expires_at = auth.credentials.expires_at
            @user.refresh_token = auth.credentials.refresh_token
            session['devise.google_data'] = auth
            session['devise.google_data'].extra = nil;
            
            
            

            render 'devise/registrations/after_social_connection'
        end
    end


    def facebook

        auth = request.env["omniauth.auth"]
        @user = User.find_by(provider: auth.provider, uid: auth.uid)
        if @user.present?
            sign_in_and_redirect @user, :event => :authentication
            flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Facebook'
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

    def github

        auth = request.env["omniauth.auth"]
        @user = User.find_by(provider: auth.provider, uid: auth.uid)
        if @user.present?
            sign_in_and_redirect @user, :event => :authentication
            flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Github'
        else
            session['devise.github_data'] = auth
            @user = User.from_omniauth(auth)
            file = URI.open(auth.info.image)
            filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_ghlimage.'+file.content_type.split("/")[1]
            blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename, content_type: file.content_type)
            @user.avatar.attach(blob)
            session[:blob_id] = blob.id
            @user.access_token = auth.credentials.token
            @user.expires_at = auth.credentials.expires_at
            session['devise.github_data'] = auth
            session['devise.github_data'].extra = nil;
            render 'devise/registrations/after_social_connection'
        end
    end

    def failure
        if (!user_signed_in?)
            flash[:notice] = "Something went wrong... Try again later or change the way to access to your account"
        end
        redirect_to root_path
    end

    private

    def set_cache_headers
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "#{1.year.ago}"
    end
end
=begin
            session["devise.facebook_data"] = request.env["omniauth.auth"]

            @user = User.from_omniauth(request.env["omniauth.auth"])
            file = URI.open(auth.info.image)
            filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_GHimage.'+file.content_type.split("/")[1]
            blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename, content_type: file.content_type)
            @user.avatar.attach(blob)
            session[:blob_id] = blob.id    
            render 'devise/registrations/after_social_connection'
        end
    end
=end



=begin
     @user = User.from_omniauth(request.env['omniauth.auth'])
        
        if @user.persisted?
          flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Github'
          sign_in_and_redirect @user, event: :authentication
        else
          session['devise.github_data'] = request.env['omniauth.auth'].except('extra') # Removing extra as it can overflow some session stores
          redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
        end
=end