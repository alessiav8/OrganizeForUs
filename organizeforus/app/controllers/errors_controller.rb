class ErrorsController < ApplicationController
    def not_found
        respond_to do |format|
            format.html { render template: 'errors/404', layout: 'layouts/application', status: 404 }
            format.all  { render nothing: true, status: 404 }
        end
    end
  
    def internal_server_error
        #ApplicationMailer.with(user: current_user, time: Time.now).error_500.deliver_now
        respond_to do |format|
            format.html { render template: 'errors/500', layout: 'layouts/application', status: 500 }
            format.all  { render nothing: true, status: 500 }
        end
    end
  end