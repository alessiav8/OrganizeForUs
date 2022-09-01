require "google/apis/calendar_v3"
require "google/api_client/client_secrets.rb"
class EventsController < ApplicationController
before_action :authenticate_user!
before_action :is_authorized? , only: [:destroy]
  include Search

 CALENDAR_ID = 'primary'
    def index
      @group=Group.find(params[:group_id])
      @events=@group.events
        #@event_list =  get_all_events(current_user)
        #@events = current_user.events
        #@try = organize_for_us(Event.first.group , '2022-08-25' , '2022-08-26' , '08:00:00' , '17:00:00' , 1)
        # <% @event_list.items.each do |event|%>
         # <li><%= event.summary%> </li>
          #<%end %>
    end
    def event_calendar; end

    def new
      @group=Group.find(params[:group_id])
      @event=Event.new
    end

    def create
      @event = Event.new(event_params)
      @group=Group.find(event_params[:group_id])
      client = get_google_calendar_client current_user
      eevent = params[:event]
      event = get_event eevent
      client.insert_event('primary', event)
      flash[:notice] = 'Event was successfully added.'
      @event.save!
      redirect_to group_events_path(@group)
      
    end

    def is_authorized
      @group=Group.find(params[:group_id])
      if @group.list_accepted.where(user_id: current_user.id).empty?
        redirect_to root_path, notice: "Not Authorized on this Group"
      end
    end


    def show
        @group=Group.find(params[:group_id])
        @event=Event.find(params[:id])
        
    end

    def get_event event
      
        attendees = event[:members].map{ |t| {email: t.strip} }        
        
        eevent = Google::Apis::CalendarV3::Event.new(
          summary: event[:title],
          location: '800 Howard St., San Francisco, CA 94103',
          description: event[:description],
          start: {
            date_time: Time.new(event['start_date(1i)'],event['start_date(2i)'],event['start_date(3i)'],event['start_date(4i)'],event['start_date(5i)']).to_datetime.rfc3339,
            time_zone: "Europe/Rome"
          },
          end: {
            date_time: Time.new(event['end_date(1i)'],event['end_date(2i)'],event['end_date(3i)'],event['end_date(4i)'],event['end_date(5i)']).to_datetime.rfc3339,
            time_zone: "Europe/Rome"
          },
          attendees: attendees,
          reminders: {
            use_default: false,
            overrides: [
              Google::Apis::CalendarV3::EventReminder.new(reminder_method:"popup", minutes: 10),
              Google::Apis::CalendarV3::EventReminder.new(reminder_method:"email", minutes: 20)
            ]
          },
          notification_settings: {
            notifications: [
                            {type: 'event_creation', method: 'email'},
                            {type: 'event_change', method: 'email'},
                            {type: 'event_cancellation', method: 'email'},
                            {type: 'event_response', method: 'email'}
                           ]
          }, 'primary': true
        )
      end

      def destroy
        @event=Event.find(params[:id])
        @group=Group.find(params[:group_id])
        respond_to do |format|
        if @event.destroy
            format.html { redirect_to group_url(@group), notice: "Event succesfully destroy." }
            format.json { render :show, status: :ok, location: @group }
        else
            format.html { redirect_to group_url(@group), notice: "Event was not successfully destroy."}
            format.json { render :edit , status: :unprocessable_entity }
        end
      end
        
      end

      def is_authorized?
        @group=Group.find(params[:group_id])
        @event=Event.find(params[:id])
        if @event.user_id!=current_user
          redirect_to group_url(@event), notice: "Not Authorized on Group"
        end
      end

    
  def event_params
    params.require(:event).permit!

  end

end