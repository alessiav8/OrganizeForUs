class GroupsController < ApplicationController
  before_action :set_group, only: [ :show, :edit ,:update ,:destroy ]
  before_action :authenticate_user!
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :delete_incomplete, only: [:index]
  before_action :surveys_terminated, only: [:show]
  before_action :member_or_admin, only: [:show]


  


  #se l'user non è autenticato non può fare nulla se non le cose specificate nella index e nella show

  # GET /groups or /groups.json
  def index
    @groups = Group.all

  end


  # GET /groups/1 or /groups/1.json
  def show
    @group=Group.find(params[:id])
    if @group.work
      render "work_group_show"
    else
      render "fun_group_show"
    end 
  end

  def show_work
  end

  def member_group
  end
  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @group=Group.find(params[:id])
    @partecipations=Partecipation.all
    if @group.work
      render "work_group_edit"
    else
      render "fun_group_edit"
    end 
  end


#forse da togliere
  def edit_driver
    @group=Group.find(params[:id])
    @member = @group.members.find_by(user_email: member_update_params[:driver])
    @group.members.update(:all, driver: "f")
    @member.update(driver: "t")
    respond_to do |format|
        format.html { redirect_to group_url(@group), notice: "the new designated driver is: "+ member_update_params[:driver] }  
    end
  end 


  # POST /groups or /groups.json
  def create
    #@group = Group.new(group_params)
    @group=current_user.groups.build(group_params)  
    respond_to do |format|
      if @group.work && @group.fun
        format.html { redirect_to groups_url,status: :unprocessable_entity, notice: "Impossible to create a group that is for fun end at the same time for work!" }
        format.json { render :show, location: @group, status: :unprocessable_entity }

      elsif @group.save 
        format.html { redirect_to new_partecipations_url(@group)}
        format.json { render :show, status: :created, location: @group }
         
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_url(@group), notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    if !@group.surveys.empty?
      @group.surveys.each{ |s|
        if !s.questions.empty?
          s.questions.each{|q|
            q.answers.destroy_all
          }
        end
      }
    end
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def delete_role
    @group=Group.find(params[:id])
  end

  def correct_user
    @group= current_user.groups.find_by(id: params[:id])
    redirect_to root_path, notice: "Not Authorized to Edit this Group" if @group.nil?
  end


  def member_or_admin
    @group=Group.find(params[:id])
    @debug= ( @group.user == current_user || !Partecipation.where(group_id: @group , user_id: current_user).empty? )
    redirect_to root_path, notice: "Not Authorized on this Group" if @debug == false
    logger.debug @debug
  end

  def set_created
    @group=Group.find(params[:id])
    var=@group.update(created:"t")
    if var #se il gruppo viene correttamente modificato
      #da spostare
      GroupMailer.with(group: @group, user: current_user).group_created.deliver_later
      respond_to do |format|
        format.html { redirect_to group_url(@group), notice: "Group was successfully created." }
        format.json { head :no_content }
      end
    else #se ci sono errori nella modifica
      @group.destroy
      respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @group.errors, status: :unprocessable_entity }
      end 
    end 
  end


  def delete_incomplete
    Group.where(created: "f",user_id: current_user.id).destroy_all
  end

  def surveys_terminated
    @group=Group.find(params[:id])
    @surveys=@group.surveys
    @surveys.each { |survey|
      totale= @group.partecipations.where('created_at < ?', survey.created_at).count
      risposte=0
      survey.questions.each{ |question|
        risposte+=question.answers.count
       }

    if totale==risposte 
      if survey.score==nil
        survey.update(score: "1")
        survey.update(terminated: true)
        notify_terminated_recipent(@group,survey)
      end
    end
     }
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:name, :description, :user_id, :fun, :work, :image)
    end

    def role_params
      params.require(:group).permit(:role)
    end


    def member_update_params
      params.require(:group).permit(:driver)
    end 
    def inside 
      @group=Group.find(params[:id])
    end

    def notify_terminated_recipent(group,survey)
      TerminatedSurveyNotification.with(survey: survey, group: group).deliver_later(group.user)
    end

    
 
end
