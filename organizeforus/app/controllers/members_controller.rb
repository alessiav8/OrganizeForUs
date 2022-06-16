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
    if @group.work!=true
      @member=@group.members.create(member_params_no_work)
    else
      @member=@group.members.create(member_work)
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
  def member_params_no_work
    params.require(:member).permit(:user_email)
  end 

  def member_update_params
    params.require(:member).permit(:driver)
  end 

  def member_work
    params.require(:member).permit(:user_email,:role,:necessary)
  end

end 

