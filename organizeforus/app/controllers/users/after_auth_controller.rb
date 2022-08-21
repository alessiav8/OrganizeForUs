class Users::AfterAuthController < Devise::OmniauthCallbacksController
    before_action :set_cache_buster


    def create
       if( session["devise.facebook_data"].present?)
            @user = User.new(user_params)
            @user.provider = session["devise.facebook_data"]["provider"]
            @user.uid = session["devise.facebook_data"]["uid"]
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
                sign_in_and_redirect @user, :event => :authentication
                set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
                
            else

                render 'devise/registrations/after_social_connection'
            end
        elsif ( session["devise.google_data"].present? )
                     
            @user = User.new(user_params)

            @user.provider = session["devise.google_data"]["provider"]
            @user.uid = session["devise.google_data"]["uid"]
        
            @user.access_token = session["devise.google_data"]["credentials"]["token"]
            @user.expires_at = session["devise.google_data"]["credentials"]["expires_at"]
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
                sign_in_and_redirect @user, :event => :authentication
                set_flash_message(:notice, :success, :kind => "Google") if is_navigational_format?
            else
                render 'devise/registrations/after_social_connection'
            end
        elsif ( session["devise.github_data"].present? )
                     
            @user = User.new(user_params)

            @user.provider = session["devise.github_data"]["provider"]
            @user.uid = session["devise.github_data"]["uid"]
        
            @user.access_token = session["devise.github_data"]["credentials"]["token"]
            @user.expires_at = session["devise.github_data"]["credentials"]["expires_at"]
      
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
                sign_in_and_redirect @user, :event => :authentication
                set_flash_message(:notice, :success, :kind => "Github") if is_navigational_format?
            else
                render 'devise/registrations/after_social_connection'
            end
        else
            flash[:notice] = "Something went wrong... Try again later or change the way to access to your account"
            redirect_to root_path
        end

    end

    def failure
        if (!user_signed_in?)
            flash[:notice] = "Something went wrong... Try again later or change the way to access to your account"
        end
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
        allowed_params = [:name, :surname, :username, :birthday, :email, :password, :password_confirmation]
        allowed_params << :avatar if !(:avatar.nil?)
     
        params.require(:user).permit(allowed_params)
    end
end