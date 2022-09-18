
class TerminatedSurveyNotification < Noticed::Base

  deliver_by :database

  def message
    @group=Group.find(params[:group][:id])
    @survey=Survey.find(params[:survey][:id])
    "Survey in #{@group.name} is completed"
  end
  #
  def url
    show_survey_path(@group, @survey=Survey.find(params[:survey][:id]))
  end
end
