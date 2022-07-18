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
    @user=Group.find(params[:group][:user_id])
    "Group #{@group.name} succesfully created"
  end
  #
  def url
   group_path(Group.find(params[:group][:id]))
  end
end
