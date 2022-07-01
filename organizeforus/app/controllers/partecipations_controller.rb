class PartecipationsController < ApplicationController
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
   
    session[:return_to] ||= request.referer 

    if @id!=nil # se esiste questo utente
      if Partecipation.where(group_id: @group).where(user_id: @id.id).empty? #se non è già membro
        
        if @g.work==true
          @partecipation=Partecipation.new(group_id: @group, user_id: @id.id, role: partecipation_params[:role])
          respond_to do |format|
            if @partecipation.save
              format.html { redirect_to session.delete(:return_to), notice: 'Member was succesfully added' }
              format.json { render :@part.json }
            else
              format.html { render :index }
              format.json { render json: @partecipation.errors, status: :unprocessable_entity }
            end
          end

        else #fun group
          
          if partecipation_params[:role]=='1'
            @g.delect_driver
            @partecipation=Partecipation.new(group_id: @group, user_id: @id.id, role: 'Driver')
            respond_to do |format|
              if @partecipation.save
                format.html { redirect_to session.delete(:return_to), notice: 'Member was succesfully added' }
                format.json { render :@part.json }
              else
                format.html { render :index }
                format.json { render json: @partecipation.errors, status: :unprocessable_entity }
              end
            end

          else
            @partecipation=Partecipation.new(group_id: @group, user_id: @id.id, role: ' ')
            respond_to do |format|
              if @partecipation.save
                format.html { redirect_to session.delete(:return_to), notice: 'Member was succesfully added'  }
                format.json { render :@part.json }
              else
                format.html { render :index }
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
      respond_to do |format|
          session[:return_to] ||= request.referer 
          format.html { redirect_to session.delete(:return_to) , notice: 'Not already sybscribe' }  
      end 
    end 

  end

  def show
    @group=Group.find(params[:group_id])
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
        format.html { redirect_to session.delete(:return_to), notice: "Designeted Driver was modify." }
        format.json { head :no_content }
      end
    else
      Partecipation.where(group_id: @group.id, user_id:@user_id.id).update(role: "Driver")
      respond_to do |format|
        session[:return_to] ||= request.referer 
        format.html { redirect_to session.delete(:return_to), notice: "Designeted Driver added." }
        format.json { head :no_content }
      end
    end
  end

private

  def partecipation_params
    params.require(:partecipation).permit(:user_id,:group_id,:role)
  end

  def role_params
    params.require(:partecipation).permit(:role)
  end

  def drive_params
    params.require(:partecipation).permit(:role)
  end

end
