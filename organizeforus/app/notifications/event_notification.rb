# To deliver this notification:
#
# GroupNotification.with(post: @post).deliver_later(current_user)
# GroupNotification.with(post: @post).deliver(current_user)

class EventNotification < Noticed::Base
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
      @event=Event.find(params[:event][:id])
      "#{@event.user.username} invite you in #{@event.title} into #{@group.name} click here to visit"
    end
  
    #
    def url
     group_event_path(Group.find(params[:group][:id]), Event.find(params[:event][:id]) )
    end
  end
  