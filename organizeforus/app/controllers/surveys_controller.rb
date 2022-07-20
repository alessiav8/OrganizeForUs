class SurveysController < ApplicationController
  def index
  end
  def new
    @survey=Survey.new
    @group=Group.find(params[:group_id])

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
        format.html { redirect_to @group, status: :created, notice: "Sondaggio Creato" }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @survey.errors, status: :unprocessable_entity }
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
 

end
