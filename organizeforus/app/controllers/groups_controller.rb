class GroupsController < ApplicationController
  before_action :set_group, only: [ :show, :edit ,:update ,:destroy ]
  before_action :authenticate_user!
  before_action :check_id, except: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update]
  before_action :only_real_admin, only:[:destroy,:set_organization]
  before_action :delete_incomplete, only: [:index]
  before_action :surveys_terminated, only: [:show]
  before_action :member_or_admin, only: [:show]

include Search
  
  def check_id
    if params[:id].nil?
      redirect_to root_path, notice: "Something goes wrong"
    end
  end


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
    #authorize! :create, @group, :message => "BEWARE: you are not authorized to create new groups."
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
        format.html { redirect_to groups_url, notice: "Impossible to create a group that is for fun end at the same time for work!" }
        format.json { render :show, location: @group, status: :unprocessable_entity }

      elsif @group.save 
        Partecipation.create(group_id: @group.id, user_id: current_user.id, accepted: true, necessary:true, role: "Admin")
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
      @group=Group.find(params[:id])
      if @group.update(name: group_params[:name],description: group_params[:description])
        format.html { redirect_to group_url(@group), notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { redirect_to edit_group_path(@group), notice: "Group was not successfully updated."}
        format.json { render :edit , status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group=Group.find(params[:id])
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
    @group = current_user.groups.find_by(id: params[:id])
      if @group.nil? 
        if !Partecipation.find_by(group_id: params[:id], user_id: current_user.id).nil?
          if Partecipation.find_by(group_id: params[:id], user_id: current_user.id).necessary == false
            redirect_to group_url(Group.find(params[:id])), notice: "Not Authorized to Edit this Group"
          end
        else 
          redirect_to group_url(Group.find(params[:id])), notice: "Not Authorized to Edit this Group"
        end
      end
  end

  def only_real_admin
    @group = current_user.groups.find_by(id: params[:id])
      if @group.nil? 
          redirect_to group_url(Group.find(params[:id])), notice: "Not Authorized on this Group"
      end
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
      sendNotification(@group)
      #quando il gruppo viene correttamente creato invia le notifiche di partecipazione

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
  def set_group
    @group = Group.find(params[:id])
  end

  def sendNotification(group)
    Partecipation.where(group_id: @group.id).each do |partecipation| #where.not(user_id: @group.user) per non includere l'admin
      notify_partecipation_recipent(@group, partecipation.user , partecipation.role)
    end
  end

  def set_organization
     @group = Group.find(params[:id])
     @start=@group.date_of_start
     @end_d=@group.date_of_end

     if @start.month.to_i < 10
      @ms="0"+@start.month.to_s
     else
      @ms=@start.month.to_s
     end

     if @end_d.month < 10
      @me="0"+@end_d.month.to_s
     else
      @me=@end_d.month.to_s
     end

     @try = organize_for_us(@group ,@start.year.to_s+"-"+@ms+"-"+@start.day.to_s , @end_d.year.to_s+"-"+@me+"-"+@end_d.day.to_s , '08:00:00' , '17:00:00' , 1)
     
     respond_to do |format|
      if @try==nil
          format.html { redirect_to group_url(@group),notice: "Not possible to find an organizzation" }
          format.json { render json: show, status: :unprocessable_entity }
      elsif @try==[]
        format.html { redirect_to group_url(@group),notice: "All members are free" }
        format.json { render json: show, status: :unprocessable_entity }
      else 
        format.html { redirect_to show_organization_path(@group),notice: "All members are free" }
        format.json { render json: show, status: :unprocessable_entity } 
      end 
    end
  end

  def stringfy_date(td)
    if td.month.to_i < 10
      ms="0"+td.month.to_s
     else
      ms=td.month.to_s
    end
     return td.year.to_s+"-"+ms+"-"+td.day.to_s 
  end

  def get_total_number_of_hour(slots)
    if slots.nil?
      return 0
    end
    return compute_total_hours(slots)

  end
  helper_method :get_total_number_of_hour

  def show_organization
    @group = Group.find(params[:id])
    # @start=@group.date_of_start
    # @end_d=@group.date_of_end

   str_s = stringfy_date(@group.date_of_start)
   str_e = stringfy_date(@group.date_of_end)



   # @group.update!(organization: @try) serve fare un metodo che data stringa restituisca i vari slots

    @slots = organize_for_us(@group ,str_s, str_e , '08:00:00' , '17:00:00' , 1)
  
  end
  helper_method :show_organization

  





  private
    # Use callbacks to share common setup or constraints between actions.


    # Only allow a list of trusted parameters through.

 def __init__(s_d=@group.date_of_start , s_e=@group.date_of_end, hs = '08:00:00' , hf = '18:00:00', dur = 1)
  @group = Group.find(params[:id])
  
  @h_p_d = []
  if !@group.nil?
    @slots = organize_for_us(@group , stringfy_date(s_d), stringfy_date(s_e) , hs , hf , 1)
    if @slots.nil?
      return [0]
    end 
    logger.debug @slots
    @slots.each do |day|
      @h_p_d << 0
      m_diff = 0
      day.each do |slot|
        m_diff = ((slot.second.hour*60)+slot.second.minute) - ((slot.first.hour*60)+slot.first.minute)
       
        @h_p_d[-1] += m_diff
      end
      logger.debug @h_p_d[-1]
      
      diff = ((@h_p_d[-1]/60).to_i + (@h_p_d[-1]%60)*0.01).round(1)
      @h_p_d[-1] = diff 
    end
  end
  @h_p_d 
 end
  helper_method :__init__




    def group_params
      params.require(:group).permit(:name, :description, :user_id, :fun, :work, :image, :color, :max_hours_in_a_day, :hours, :date_of_start, :date_of_end)
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

    def notify_partecipation_recipent(group,user,role)
      GroupNotification.with(group: group, user: user, creator: group.user,role: role).deliver_later(user) # creazione notifiche
    end
    
 
end
