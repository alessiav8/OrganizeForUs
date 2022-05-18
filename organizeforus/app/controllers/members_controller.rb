class MembersController < ApplicationController
  def index
  end

  def new
    @group=Group.find(params[:group_id])
  end

  def create
    @group=Group.find(params[:group_id])
    @member=@group.members.create(member_params)
    redirect_to groups_path
  end
  

private
  def member_params
    @user=User.find_by(id: params[:user])
    redirect_to @group ,notice: "Not Good" if @user.nil? 

  end 
end 

