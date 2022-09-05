# To deliver this notification:
#
# SurveyNotification.with(post: @post).deliver_later(current_user)
# SurveyNotification.with(post: @post).deliver(current_user)

class SurveyNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  # def message
  #   t(".message")
  # end
  def message
    @group=Group.find(params[:group][:id])
    @survey=Survey.find(params[:survey][:id])
    "There is a new survey in #{@group.name} please reply!"
  end
  #
  def url
    @group=Group.find(params[:group][:id])
    @survey=Survey.find(params[:survey][:id])
    @user=User.find(params[:user][:id])
    invite_survey_path(@group,@survey,@user)
  end
  # def url
  #   post_path(params[:post])
  # end
end
