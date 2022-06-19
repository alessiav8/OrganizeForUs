class PartecipationsController < ApplicationController
  def index
  end

  def new
    @partecipation=Partecipation.new
    @group=Group.find(params[:group_id])
  end

  def create
    @user=partecipation_params[:user_id]
    if User.find_by(email: @user)!=nil
        @partecipation=Partecipation.new(group_id: partecipation_params[:group_id], user_id: User.find_by(email: @user).id)
        respond_to do |format|
        if @partecipation.save
            format.html { redirect_to '/', notice: 'Member was succesfully added' }
            format.json { render :@part.json }
          else
            format.html { render :index }
            format.json { render json: @partecipation.errors, status: :unprocessable_entity }
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

  def new_role
    
  end

private

  def partecipation_params
    params.require(:partecipation).permit(:user_id,:group_id)
  end

  def role_params
    params.require(:partecipation).permit(:role)
  end

end
