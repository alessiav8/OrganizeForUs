class MembersController < ApplicationController
  def index
  end

  def new
    @gruppo=Gruppo.find(params[:gruppo_id])
  end

  def create
    @gruppo=Gruppo.find(params[:gruppo_id])
    @member=@gruppo.members.create(member_params)
    redirect_to gruppos_path
  end
  

private
  def member_params
    @user=User.find_by(id: params[:user])
    redirect_to @gruppo ,notice: "Not Good" if @user.nil? 

  end 
end 

