class PostMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.post_mailer.post_created.subject
  #
  def post_created
    @greeting = "Hi"
    @user= params[:user]
    @creator= params[:creator]
    @group= params[:group]

    mail(
      to: @user ,
      subject: @creator + "invite you to join the Organize for us Family"
    )
  end
end
