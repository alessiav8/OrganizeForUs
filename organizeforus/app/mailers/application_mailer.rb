class ApplicationMailer < ActionMailer::Base
  default from: 'organizeforus@gmail.com'
  layout 'mailer'

  def error_500
    
    @user = params[:user]
    @time = params[:time]

    mail(  
      to: "organizeforus@gmail.com" ,
      subject: "Huston, we have a Server Error!!",
    )
  end

end

