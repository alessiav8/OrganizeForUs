
class SurveyNotification < Noticed::Base

  deliver_by :database
 
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

end
