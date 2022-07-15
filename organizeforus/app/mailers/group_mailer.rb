class GroupMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.group_mailer.group_created.subject
  #
  def group_created
    @greeting = "Hi"
    @group=params[:group]
    @user=params[:user]
    @url= "http://localhost:3000/groups/"

    mail(
      to: String(@user.email) ,
      subject: "Group "+@group.name+" created!",
    )
  end

  def join_comunity
    @group=params[:group]
    @user=params[:user]
    @creator=params[:creator]
    @url="http://localhost:3000/users/sign_up"
    mail(
      to: String(@user),
      subject: @creator.name + " Invite you!",
    )
  end

end
