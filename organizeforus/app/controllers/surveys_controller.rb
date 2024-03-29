class SurveysController < ApplicationController

  before_action :is_autorized?, only: [:create, :new, :destroy]
  before_action :correct_user?, only: [:index, :show]

  def index
    @group=Group.find(params[:group_id])
    @surveys=@group.surveys
  end
  def new
    #authorize! :create, @survey, :message => "BEWARE: you are not authorized to create new surveys."
    @survey=Survey.new
    @group=Group.find(params[:group_id])

  end

  def show
    @survey=Survey.find(params[:survey_id])
    if @survey.group.is_administrator?(current_user) && @survey.is_terminated?
      mark_notification_as_read
    end
  end

  def create
    @group=Group.find(params[:group_id])
    @survey=@group.surveys.build(title: survey_params[:title],body: survey_params[:body])
    @survey.user=@group.user

    @survey.questions.build(title: survey_params[:question][:title])
    @qs=survey_params[:questions_attributes]
    if @qs!=nil
      @qs.each{|q| q.each{ |n| 
        if @qs[n]!=nil
          @survey.questions.build(title: survey_params[:questions_attributes][n][:title] )
        end
        }
      }
    end
    respond_to do |format|
      if @survey.save 
        @members=@group.list_accepted
        if !@members.empty?
          @members.each{ |m|
            notify_recipent(@survey,@group,m.user)
          }
        end
        format.html { redirect_to index_survey_path(@group), notice: "Survey created" }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { redirect_to index_survey_path(@group), notice: "Survey not created, wrong attributes passed"}
        format.json { render json: @survey.errors, status: :unprocessable_entity }
      end
    end
  end

  def invite
    @group=Group.find(params[:group_id])
    @user=User.find(params[:user_id])
    @survey=Survey.find(params[:survey_id])
    @answer=Answer.new
  end

  def answer
    @group=Group.find(params[:group_id])
    @user=User.find(params[:user_id])
    @survey=Survey.find(params[:survey_id])
    @answer = @survey.answers.build(question_id: answer_params[:question_id], user_id: current_user.id);
    logger.debug "RISPOSTA SONDAGGIO  #{answer_params[:question_id]}"

    respond_to do |format|
      if @answer.save
        mark_notification_as_read
        format.html { redirect_to group_url(@group), notice: "Thank you for your answer!"} 
      else
        format.html { redirect_to group_url(@group), notice: "Something goes wrong!"} 
      end
  end
  end

  def destroy
    @survey=Survey.find(params[:id]) 
    @survey.questions.each do |question|
      question.answers.destroy_all
    end
    respond_to do |format|
      if @survey.destroy
        format.html { redirect_to group_url(@survey.group), notice: "Survey destroyed!"} 
        format.json { head :no_content }
      else
        format.html { redirect_to group_url(@survey.group), notice: "Survey not destroyed!"} 
        format.json { head :no_content }
      end

    end
  end

  def is_autorized?
    if params[:group_id].nil?
      @survey=Survey.find(params[:id]) 
      group=@survey.group
      if !group.is_administrator?(current_user)
        redirect_to group_url(@group), notice: "Not Authorized to Create Survey"
      end

    else
      @group=Group.find(params[:group_id])
      if !@group.is_administrator?(current_user)
        redirect_to group_url(@group), notice: "Not Authorized to Create Survey"
      end
    end

  end

  def correct_user? 
    @group=Group.find(params[:group_id])
    if @group.user != current_user
      if Partecipation.find_by(group_id:@group, user_id: current_user).nil?
          redirect_to root_path, notice: "Not Authorized on this Group"
      end
    end
 end




  private
  def survey_params
    params.require(:survey).permit(:title, :body, question: [:title,:_destroy], questions_attributes: [:id,:title,:_destroy])
  end
  def question_params
    params.require(:survey).permit(question: [:title])
  end

  def notify_recipent(survey,group,user)
    SurveyNotification.with(survey: survey,group: group,user: user).deliver_later(user) # creazione notifiche
  end

  def mark_notification_as_read
    @survey=Survey.find(params[:survey_id])
    if current_user
      notifications_to_mark_as_read= @survey.notifications_as_survey.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end

  def answer_params
    params.require(:answer).permit(:question_id)
  end

 

end
