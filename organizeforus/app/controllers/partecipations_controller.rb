class PartecipationsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_authorized? , only: [:new, :create]
  before_action :correct_user?, only: [:new,:create,:show,:update]
  before_action :check_admin, only: [:show]
  
  def index
  end

  def new
    @partecipation=Partecipation.new
    @partecipations=Partecipation.all
    @group=Group.find(params[:group_id])
    if @group.fun
      if @group.created?
        render "member_fun"
      else
        render "new_fun"
      end
    else
      if @group.created?
        render "member_work"
      else
        render "new_work"
      end
  end
end

  def create
    @user=partecipation_params[:user_id]
    @id=User.find_by(email: @user)
    @group=partecipation_params[:group_id]
    @g=Group.find(@group)
    @color= partecipation_params[:role_color]
    @role= partecipation_params[:role]
    if @role == "" || @role == " " || @role== nil
      @role="No Role"
    end

   
    session[:return_to] ||= request.referer 

    if @id!=nil # se esiste questo utente
      if Partecipation.where(group_id: @group).where(user_id: @id.id).empty? #se non è già membro
        if @g.created=="t" 
          notify_recipent(@g,@id,@role) 
        end #invia notifica per accettare o meno l'invito al gruppo
        
        if @g.work==true
          @partecipation=Partecipation.new(group_id: @group, user_id: @id.id, role: @role, role_color: @color, necessary: partecipation_params[:necessary])
          respond_to do |format|
            if @partecipation.save
              format.html { redirect_to session.delete(:return_to), notice: 'Member was succesfully added' }
              format.json { render :@part.json }
            else
              format.html { render html: "Something gone wrong"+ @partecipation.errors}
              format.json { render json: @partecipation.errors, status: :unprocessable_entity }
            end
          end

        else #fun group
          
          if @role=='1' #E DD
            @g.delect_driver
            @partecipation=Partecipation.new(group_id: @group, user_id: @id.id, role: 'Driver', necessary: false)
            respond_to do |format|
              if @partecipation.save
                format.html { redirect_to session.delete(:return_to), notice: 'Member was succesfully added' }
                format.json { render :@part.json }
              else
                format.html { render html: "Something gone wrong"+ @partecipation.errors}
                format.json { render json: @partecipation.errors, status: :unprocessable_entity }
              end
            end

          else # non è DD
            @partecipation=Partecipation.new(group_id: @group, user_id: @id.id, role: 'No Role',necessary: false)
            respond_to do |format|
              if @partecipation.save
                format.html { redirect_to session.delete(:return_to), notice: 'Member was succesfully added'  }
                format.json { render :@part.json }
              else
                format.html { render html: "Something gone wrong"+ @partecipation.errors}
                format.json { render json: @partecipation.errors, status: :unprocessable_entity }
              end
            end
          end 

        end 

      else
        respond_to do |format|
            format.html { redirect_to session.delete(:return_to), notice: 'Member was already subscribe' }
            format.json { render :@part.json }
        end
      end 

    else 
      if @user!=nil && @user!=" "
        GroupMailer.with(group: @g,user: @user, creator: current_user).join_comunity.deliver_later
      end
      respond_to do |format|
        format.html { redirect_to session.delete(:return_to), notice: 'Sent invite' }
        format.json { render :@part.json }
       end       
    end 

  end

  def show
    @group=Group.find(params[:group_id])
    if @group.fun
        render "show_fun"
    else
        render "show_work"
    end

  end

  def destroy
    @partecipation=Partecipation.find(params[:id])
    @partecipation.destroy

    respond_to do |format|
      session[:return_to] ||= request.referer 

      format.html { redirect_to session.delete(:return_to), notice: "Member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def edit_driver
    @group=Group.find(params[:id])
    @user_id=User.find_by(email: drive_params[:role])
    if @group.has_designeted_driver?
      @group.delect_driver
      Partecipation.where(group_id: @group.id, user_id:@user_id.id).update(role: "Driver")
      respond_to do |format|
        session[:return_to] ||= request.referer 
        format.html { redirect_to session.delete(:return_to), notice: "Designated Driver was modified." }
        format.json { head :no_content }
      end
    else
      Partecipation.where(group_id: @group.id, user_id:@user_id.id).update(role: "Driver")
      respond_to do |format|
        session[:return_to] ||= request.referer 
        format.html { redirect_to session.delete(:return_to), notice: "Designated Driver added." }
        format.json { head :no_content }
      end
    end
  end

  def delete_role
    @group=Group.find(params[:group_id])
    @role=params[:role]
    Partecipation.where(role: @role).update(role: "No Role")
    respond_to do |format|
      session[:return_to] ||= request.referer 
      format.html { redirect_to session.delete(:return_to), notice: "Role: "+@role+" was deleted, the member who had that role now are general member, please update their position if you need " }
      format.json { head :no_content }
    end
  end

  def update_role
    @group=Group.find(params[:group_id])
    @member=User.find(params[:member_id])
    @color=params[:role_color]
    @role=params[:role]
    @admin=params[:necessary]
    @part=Partecipation.find_by(group_id: @group.id, user_id: @member.id)
    if @role != nil && @role != ""
      if @role==@part.role && ( @part.necessary==true && @admin=="0")
        @part.update(role: "No Role", role_color: @color, necessary: @admin)
      else
       @part.update(role: params[:role], role_color: @color, necessary: @admin)
       respond_to do |format|
        format.html { redirect_to show_p_url(@group), notice: "Role updated" }
        format.json { head :no_content }
        
       end
      end
    else
      respond_to do |format|
        format.html { redirect_to show_p_url(@group), notice: "Empty role" }
        format.json { head :no_content }
      end
    end

  end

  def update
    @group=Group.find(params[:group_id])
    @member=User.find(params[:member_id])
    render "update_role"
  end


  def invite 
    @group=Group.find(params[:group_id])
    @user=User.find(params[:member_id])
    @partecipation= Partecipation.where(group_id: @group.id, user_id: @user.id).take
    mark_notification_as_read
  end

  def accept
    @partecipation=Partecipation.find(params[:id])
    @partecipation.update(accepted: true)
    @group=Group.find(@partecipation.group_id)
    flash.alert="Accept"
    respond_to do |format|
      format.html { redirect_to group_url(@group), notice: "Accepted" }
      format.json { head :no_content }
    end

  end

  def decline
    @partecipation=Partecipation.find(params[:id])
    @partecipation.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: "Declined" }
      format.json { head :no_content }
    end
  end

  def getRole(user,group)
    Partecipation.where(group_id: group.id, user_id: User.where(email: user.email).take.id ).take.role
  end

=begin
  def correct_user 
    if current_user==
      true
    end
  end
=end

def is_authorized? 
   @group=Group.find(params[:group_id])
   if @group.user != current_user
    if !Partecipation.find_by(group_id:@group, user_id: current_user).nil?
      if Partecipation.find_by(group_id:@group, user_id: current_user).necessary == false
        redirect_to group_url(@group), notice: "Not Authorized to create Partecipation on this Group"
      end
    else 
      redirect_to group_url(@group), notice: "Not Authorized to create Partecipation on this Group"
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

def check_admin
  @group=Group.find(params[:group_id])
  @group.partecipations.each do |p|
    if p.necessary==true
      p.update!(role: "Admin")
    end
  end
end




private

  def partecipation_params
    params.require(:partecipation).permit(:user_id,:group_id,:role,:role_color,:necessary)
  end

  def role_params
    params.require(:partecipation).permit(:role)
  end

  def drive_params
    params.require(:partecipation).permit(:role)
  end

  def mark_notification_as_read
    @group=Group.find(params[:group_id])
    if current_user
      notifications_to_mark_as_read= @group.notifications_as_group.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end

  def notify_recipent(group,user,role)
    g=GroupNotification.with(group: group, user: user, creator: group.user,role: role).deliver_later(user) # creazione notifiche
  end




end
