class MembersController < ApplicationController
  def index
  end

  def new
    @group=Group.find(params[:group_id])
  end

  def show
    @group=Group.find(params[:group_id])

  end

  def create
    @group=Group.find(params[:group_id])
    member=@group.members.create(member_params)
    
    @user=User.find_by(email: params[:user_email])
    if @user.nil? 
      member.update(iscritto: 'false')
    else 
      member.update(iscritto: 'true')
    end 
    redirect_to group_url(@group)

  end

  def destroy
    @group=Group.find(params[:group_id])
    @member = @group.members.find(params[:id])
    @member.destroy

    respond_to do |format|
      format.html { redirect_to @group, notice: "Member was successfully destroyed." }
      format.json { head :no_content }
    end
  end 

private
  def member_params
    params.require(:member).permit(:user_email)
  end 

end 

