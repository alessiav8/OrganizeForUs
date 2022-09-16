class Users::AfterAuthController < Devise::OmniauthCallbacksController
    before_action :set_cache_buster
    before_action :user_params, except: [:unlink_account]

    def create
       if( session["devise.facebook_data"].present?)
            @user = User.new(user_params)
            @user.fb_access_token = session["devise.facebook_data"]["credentials"]["token"]
            @user.fb_expires_at = get_expiration_time(session["devise.facebook_data"]["credentials"]["expires_at"].seconds)
            file = user_params[:avatar]
            if (!file.nil?)
                filename = filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_Upimage.'+(file.content_type.split("/")[1])
                blob = ActiveStorage::Blob.create_and_upload!(io: user_params[:avatar], filename: filename, content_type: file.content_type)
                if (blob.byte_size <= 5242880)
                    @user.avatar.attach(blob)
                    session[:blob_id] = blob.id
                end
            elsif (!@user.avatar.attached?)
                @user.avatar.attach(ActiveStorage::Blob.find_by(id: session[:blob_id]))
            end
            if @user.save
                session[:blob_id] = nil
                @user.identities.create(provider: session["devise.facebook_data"]["provider"], uid: session["devise.facebook_data"]["uid"])
                sign_in_and_redirect @user, :event => :authentication
                set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
                
            else

                render 'devise/registrations/after_social_connection'
            end
        elsif ( session["devise.google_data"].present? )
                     
            @user = User.new(user_params)
            #tentativo di setting di roles_mask come user per login tramite google
            #@user.roles_mask = :user
        
            @user.gh_access_token = session["devise.google_data"]["credentials"]["token"]
            @user.expires_at = get_expiration_time(session["devise.google_data"]["credentials"]["expires_at"].seconds)
            @user.refresh_token = session["devise.google_data"]["credentials"]["refresh_token"]

            file = user_params[:avatar]
            if (!file.nil?)
                filename = filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_Upimage.'+(file.content_type.split("/")[1])
                blob = ActiveStorage::Blob.create_and_upload!(io: user_params[:avatar], filename: filename, content_type: file.content_type)
                if (blob.byte_size <= 5242880)
                    @user.avatar.attach(blob)
                    session[:blob_id] = blob.id
                end
            elsif (!@user.avatar.attached?)
                @user.avatar.attach(ActiveStorage::Blob.find_by(id: session[:blob_id]))
            end

            if @user.save
                session[:blob_id] = nil
                @user.identities.create(provider: session["devise.google_data"]["provider"], uid: session["devise.google_data"]["uid"])
                sign_in_and_redirect @user, :event => :authentication
                set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
            else
                render 'devise/registrations/after_social_connection'
            end
        elsif ( session["devise.github_data"].present? )
                     
            @user = User.new(user_params)

            #@user.provider = session["devise.github_data"]["provider"]
            #@user.uid = session["devise.github_data"]["uid"]
        
            @user.gh_access_token = session["devise.github_data"]["credentials"]["token"]
            #@user.expires_at = session["devise.github_data"]["credentials"]["expires_at"]
      
            #@user.access_token = session["devise.github_data"]["credentials"]["token"] + "&token_type=bearer&scope=public_repo%2Cgist"
            @user.gh_username = session["devise.github_data"]["info"]["nickname"]
            
            file = user_params[:avatar]
            if (!file.nil?)
                filename = filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_Upimage.'+(file.content_type.split("/")[1])
                blob = ActiveStorage::Blob.create_and_upload!(io: user_params[:avatar], filename: filename, content_type: file.content_type)
                if (blob.byte_size <= 5242880)
                    @user.avatar.attach(blob)
                    session[:blob_id] = blob.id
                end
            elsif (!@user.avatar.attached?)
                @user.avatar.attach(ActiveStorage::Blob.find_by(id: session[:blob_id]))
            end

            if @user.save
                session[:blob_id] = nil
                @user.identities.create(provider: session["devise.github_data"]["provider"], uid: session["devise.github_data"]["uid"])
                sign_in_and_redirect @user, :event => :authentication
                set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
            else
                render 'devise/registrations/after_social_connection'
            end
        elsif ( session["devise.linkedin_data"].present? )
 
            @user = User.new(user_params)
        
            #@user.l_access_token = session["devise.linkedin_data"]["credentials"]["token"]
            #@user.l_expires_at = session["devise.linkedin_data"]["credentials"]["expires_at"]
      
            file = user_params[:avatar]
            if (!file.nil?)
                filename = filename = 'OrganizeForUs_'+SecureRandom.hex(5)+'_Upimage.'+(file.content_type.split("/")[1])
                blob = ActiveStorage::Blob.create_and_upload!(io: user_params[:avatar], filename: filename, content_type: file.content_type)
                if (blob.byte_size <= 5242880)
                    @user.avatar.attach(blob)
                    session[:blob_id] = blob.id
                end
            elsif (!@user.avatar.attached?)
                @user.avatar.attach(ActiveStorage::Blob.find_by(id: session[:blob_id]))
            end

            if @user.save
                session[:blob_id] = nil
                @user.identities.create(provider: session["devise.linkedin_data"]["provider"], uid: session["devise.linkedin_data"]["uid"])
                sign_in_and_redirect @user, :event => :authentication
                set_flash_message(:notice, :success, :kind => "Linkedin") if is_navigational_format?
            else
                render 'devise/registrations/after_social_connection'
            end
        else
            flash[:notice] = "Something went wrong... Try again later or change the way to access to your account"
            redirect_to root_path
        end

    end

    def unlink_account
        if user_signed_in?
            if current_user.id === eval(params[:id])
                @user = User.find_by(id: params[:id])
                auth = @user.identities.where(provider: params[:provider])
                if auth
                    auth.first.destroy
                    if params[:provider] == "google_oauth2"
                        @user.update(access_token: nil, expires_at: nil, refresh_token: nil)
                        flash[:notice] = "Google account successfully unlinked!"
                    elsif params[:provider] == "facebook"
                        @user.update(fb_access_token: nil, fb_expires_at: nil)
                        flash[:notice] = "Facebook account successfully unlinked!"
                    elsif params[:provider] == "github"
                        @user.update(gh_access_token: nil)
                        flash[:notice] = "Github account successfully unlinked!"
                    elsif params[:provider] == "linkedin"
                        flash[:notice] = "Linkedin account successfully unlinked!"
                    end
                    redirect_to profile_path
                end
            else
                redirect_to root_path
            end
        else
            redirect_to new_user_registration_path
        end
    end

    def failure
        if (!user_signed_in?)
            flash[:notice] = "Something went wrong... Try again later or change the way to access to your account"
        end
        redirect_to root_path
    end

    def handle_unverified_request
        flash[:notice] = "NOPE!"
        redirect_to root_path
    end

    protected

    def set_cache_buster
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "#{1.year.ago}"
    end

    private
    
    def user_params
        if user_signed_in?
            allowed_params = [:id, :provider]
            flash[:notice] = "You're not allowed..." unless current_user.id === eval(params[:id])
            flash[:notice] = "Seriously... You're not allowed..." unless Identity.providers_list.include?(params[:provider])
            redirect_to profile_path
        elsif  params[:user].nil?
            redirect_to root_path
        else
            allowed_params = [:name, :surname, :username, :birthday, :email, :password, :password_confirmation, :gh_username]
            allowed_params << :avatar unless :avatar.nil?
        end
        params.require(:user).permit(allowed_params) unless params[:user].nil?
    end

    def get_expiration_time(seconds)
        jan1970 = DateTime.rfc3339("1970-01-01T00:00:00Z")
        jan1970 + seconds
    end
end