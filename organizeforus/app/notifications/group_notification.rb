# To deliver this notification:
#
# GroupNotification.with(post: @post).deliver_later(current_user)
# GroupNotification.with(post: @post).deliver(current_user)

class GroupNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    @group=Group.find(params[:group][:id])
    @user=User.find(params[:user][:id])
    @creator=User.find(params[:creator][:id])
    
    "#{@group.user.name} invite you in #{@group.name} Group click here to accept"
  end

  #
  def url
   invite_path(Group.find(params[:group][:id]), User.find(params[:user][:id]) )
  end
end
