

class EventNotification < Noticed::Base

    deliver_by :database
 
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
  