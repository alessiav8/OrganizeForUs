require 'open-uri'

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :set_cache_headers

    def google_oauth2
        auth = request.env["omniauth.auth"]
        if user_signed_in?
            @user = User.find_by(id: current_user.id)
            if @user.identities.where(provider: "google_oauth2").empty?
                if Identity.where(provider: auth.provider, uid: auth.uid).empty?
                    @user.update!(access_token: auth.credentials.token, 
                                  expires_at: get_expiration_time(auth.credentials.expires_at.seconds), 
                                  refresh_token: auth.credentials.refresh_token )
                    @user.identities.create(provider: auth.provider, uid: auth.uid)
                    flash[:notice] = "Google account successfully linked!"
                else
                    flash[:notice] = "It seems that you have another account linked with your Google account... Unlink it on the other account and then try again!"
                end
            end
            redirect_to profile_path
        else
            
            authentication = Identity.find_by(provider: auth.provider, uid: auth.uid)
      
            if authentication.present?
                
                @user = authentication.user
                
                @user.update!(access_token: auth.credentials.token, expires_at: get_expiration_time(auth.credentials.expires_at.seconds), refresh_token: auth.credentials.refresh_token)
                sign_in_and_redirect @user, :event => :authentication
                flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
            else
                @user = User.from_omniauth(auth)
                if(auth.info.image)
                    file = URI.open(auth.info.image)
                    filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_gglimage.'+file.content_type.split("/")[1]
                    blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename, content_type: file.content_type)
                    @user.avatar.attach(blob)
                    session[:blob_id] = blob.id
                end
                @user.access_token = auth.credentials.token
                @user.expires_at = get_expiration_time(auth.credentials.expires_at.seconds)
                @user.refresh_token = auth.credentials.refresh_token
                session['devise.google_data'] = auth
                session['devise.google_data'].extra = nil;
                
                
                

                render 'devise/registrations/after_social_connection'
            end
        end
    end

    def facebook

        auth = request.env["omniauth.auth"]
        if user_signed_in?
            @user = User.find_by(id: current_user.id)
            if @user.identities.where(provider: "facebook").empty?
                if Identity.where(provider: auth.provider, uid: auth.uid).empty?
                    @user.update!(fb_access_token: auth.credentials.token, 
                                  fb_expires_at: get_expiration_time(auth.credentials.expires_at.seconds))
                    @user.identities.create(provider: auth.provider, uid: auth.uid)
                    flash[:notice] = "Facebook account successfully linked!"
                else
                    flash[:notice] = "It seems that you have another account linked with your Facebook account... Unlink it on the other account and then try again!"
                end
            end
            redirect_to profile_path
        else
            authentication = Identity.find_by(provider: auth.provider, uid: auth.uid)
            if authentication.present?
                @user = authentication.user
                @user.update!(fb_access_token: auth.credentials.token, fb_expires_at: get_expiration_time(auth.credentials.expires_at.seconds))
                sign_in_and_redirect @user, :event => :authentication
                flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Facebook'
            else
                session["devise.facebook_data"] = request.env["omniauth.auth"]

                @user = User.from_omniauth(request.env["omniauth.auth"])
                if(auth.info.image)
                    file = URI.open(auth.info.image)
                    filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_fbimage.'+file.content_type.split("/")[1]
                    blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename, content_type: file.content_type)
                    @user.avatar.attach(blob)
                    session[:blob_id] = blob.id   
                end
                @user.fb_access_token = auth.credentials.token
                @user.fb_expires_at = get_expiration_time(auth.credentials.expires_at.seconds)

                render 'devise/registrations/after_social_connection'
            end
        end
    end

    def github

        auth = request.env["omniauth.auth"]
        if user_signed_in?
            @user = User.find_by(id: current_user.id)
            if @user.identities.where(provider: "github").empty?
                if Identity.where(provider: auth.provider, uid: auth.uid).empty?
                    @user.update!(gh_access_token: auth.credentials.token, gh_username: auth.extra.raw_info.login)

                    @user.identities.create(provider: auth.provider, uid: auth.uid)
                    flash[:notice] = "Github account successfully linked!"
                else
                    flash[:notice] = "It seems that you have another account linked with your Github account... Unlink it on the other account and then try again!"
                end
            end
            redirect_to profile_path
        else
            authentication = Identity.find_by(provider: auth.provider, uid: auth.uid)
            if authentication.present?
                @user = authentication.user
                sign_in_and_redirect @user, :event => :authentication
                flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Github'
            else
                session['devise.github_data'] = auth
                @user = User.from_omniauth(auth)
                if(auth.info.image)
                    file = URI.open(auth.info.image)
                    filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_ghlimage.'+file.content_type.split("/")[1]
                    blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename, content_type: file.content_type)
                    @user.avatar.attach(blob)
                    session[:blob_id] = blob.id
                end
                
                @user.gh_access_token = auth.credentials.token
                @user.gh_username = auth.extra.raw_info.login
                session['devise.github_data'] = auth
                session['devise.github_data'].extra = nil;
                render 'devise/registrations/after_social_connection'
            end
        end
    end

    def linkedin
        auth = request.env["omniauth.auth"]
        if user_signed_in?
            @user = User.find_by(id: current_user.id)
            if @user.identities.where(provider: "Linkedin").empty?
                if Identity.where(provider: auth.provider, uid: auth.uid).empty?
                    @user.identities.create(provider: auth.provider, uid: auth.uid)
                    flash[:notice] = "Linkedin account successfully linked!"
                else
                    flash[:notice] = "It seems that you have another account linked with your Linkedin account... Unlink it on the other account and then try again!"
                end
            end
            redirect_to profile_path
        else
            authentication = Identity.find_by(provider: auth.provider, uid: auth.uid)
            if authentication.present?
                @user = authentication.user
                sign_in_and_redirect @user, :event => :authentication
                flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Linkedin'
            else
                session["devise.linkedin_data"] = request.env["omniauth.auth"]
                
                @user = User.from_omniauth(request.env["omniauth.auth"])
                if (auth.info.picture_url)
                    file = URI.open(auth.info.picture_url)
                    filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_lkimage.'+file.content_type.split("/")[1]
                    blob = ActiveStorage::Blob.create_and_upload!(io: file, filename: filename, content_type: file.content_type)
                    @user.avatar.attach(blob)
                    session[:blob_id] = blob.id
                end    
                render 'devise/registrations/after_social_connection'
            end
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

    def user_params
        allowed_params = [:name, :surname, :username, :birthday, :email, :password, :password_confirmation]
        allowed_params << :avatar unless :avatar.nil?
     
        params.require(:user).permit(allowed_params)
    end

    def get_expiration_time(seconds)
        jan1970 = DateTime.rfc3339("1970-01-01T00:00:00Z")
        jan1970 + seconds
    end

    def handle_unverified_request
        super
        flash[:notice] = "NOPE!"
        redirect_to root_path
    end
end
