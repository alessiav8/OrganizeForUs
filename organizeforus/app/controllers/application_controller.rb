class ApplicationController < ActionController::Base
    #inizio modifiche cancan
    rescue_from CanCan::AccessDenied do |exception|
        redirect_to root_path, :alert => exception.message
    end
    #fine modifiche di cancan

    protect_from_forgery with: :exception, prepend: true

    before_action :configure_permitted_parameters, if: :devise_controller?
    before_action :set_notifications, if: :current_user




    protected

    def configure_permitted_parameters
        allowed_params = [:name, :surname, :username, :birthday]
        allowed_params << :avatar unless :avatar.nil?

        devise_parameter_sanitizer.permit(:sign_up, keys: allowed_params)  #Permette di inserire nell'user il nome, il cognome, il nickname e la data di nascita
        devise_parameter_sanitizer.permit(:account_update, keys: allowed_params) #Permette di aggiornare e dunque visualizzare i suddetti attributi aggiuntivi
        devise_parameter_sanitizer.permit :sign_in, keys: [:login, :password]
    end

    def set_notifications
        notification= Notification.where(recipient: current_user).newest_first.limit(9).unread
        @unread=notification.unread
        @read=notification.read
    end

end
