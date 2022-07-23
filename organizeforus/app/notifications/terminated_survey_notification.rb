# To deliver this notification:
#
# TerminatedSurveyNotification.with(post: @post).deliver_later(current_user)
# TerminatedSurveyNotification.with(post: @post).deliver(current_user)

class TerminatedSurveyNotification < Noticed::Base
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
    "Survey in #{@group.name} is completed"
  end
  #
  def url
    show_survey_path( @survey=Survey.find(params[:survey][:id]))
  end
end
