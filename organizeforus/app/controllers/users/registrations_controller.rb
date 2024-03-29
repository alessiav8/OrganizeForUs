class Users::RegistrationsController < Devise::RegistrationsController
    before_action :set_cache_buster, only: [:new]

    def destroy
      if @user.destroy_with_password(params[:user][:password_for_delete])
        flash[:notice] = "Your account has been deleted"
        redirect_to root_path    
      else                       
        render :edit, layout: 'application'                                                 
      end  
    end
    

    protected

    def set_cache_buster
        response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
        response.headers["Pragma"] = "no-cache"
        response.headers["Expires"] = "#{1.year.ago}"
    end


end