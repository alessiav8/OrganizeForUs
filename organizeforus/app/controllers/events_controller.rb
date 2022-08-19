class EventsController < ApplicationController
    before_action :is_a_member, only: [:show]


    def index
        @group=Group.find(params[:group_id])
        @events=Event.where(group_id: @group.id)
    end

    def new
        @group=Group.find(params[:group_id])
        @event=Event.new
    end

    def create
        @group=Group.find(params[:group_id])
        @event=Event.new(event_params)
        respond_to do |format|
            if @event.save
              format.html { redirect_to group_events_url(@group),status: :unprocessable_entity, notice: "Event created!" }
              format.json { render :show, location: @group, status: :unprocessable_entity }
            else
              format.html { render :new, status: :unprocessable_entity }
              format.json { render json: @group.errors, status: :unprocessable_entity }
            end
          end
    end

    def show
        @event=Event.find(params[:id])

    end


    def is_a_member
        @event=Event.find(params[:id])
        if current_user==@event.user 
            return true
        end
    end

    private
        def event_params
            params.require(:event).permit(:group_id, :user_id,:name, :description, :type_of_houre, :type_of_presence, :houres)
        end

end
