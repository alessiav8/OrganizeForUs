# To deliver this notification:
#
# GroupNotification.with(post: @post).deliver_later(current_user)
# GroupNotification.with(post: @post).deliver(current_user)

class GroupNotification < Noticed::Base

  deliver_by :database

  def message
    @group=Group.find(params[:group][:id])
    @user=User.find(params[:user][:id])
    @creator=User.find(params[:creator][:id])
    @role= params[:role]
    
    "#{@group.user.username} invite you in #{@group.name} Group click here to accept"
  end

  #
  def url
   invite_path(Group.find(params[:group][:id]), User.find(params[:user][:id]) )
  end
end
