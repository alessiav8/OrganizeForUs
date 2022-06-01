class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception, prepend: true

    before_action :configure_permitted_parameters, if: :devise_controller?

    protected

        def configure_permitted_parameters  
            devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :surname, :username, :birthday, :provider, :uid])  #Permette di inserire nell'user il nome, il cognome, il nickname e la data di nascita
            devise_parameter_sanitizer.permit(:account_update, keys: [:name, :surname, :username, :birthday]) #Permette di aggiornare e dunque visualizzare i suddetti attributi aggiuntivi
        end
    
end
