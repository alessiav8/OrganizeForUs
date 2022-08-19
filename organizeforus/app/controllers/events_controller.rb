require "google/apis/calendar_v3"
require "google/api_client/client_secrets.rb"
class EventsController < ApplicationController

 CALENDAR_ID = 'primary'
    def index
        #@group=Group.find(params[:group_id])
        #@events=Event.where(group_id: @group.id)
        @events = current_user.events
       # @group=Group.find(params[:group_id])
       #  @events=Event.where(group_id: @group.id)
    end

    def new
        #@group=Group.find(params[:group_id])
        @event=Event.new
        #@group=Group.find(params[:group_id])
       
    end

    def create
       # @group=Group.find(params[:group_id])
        @event=Event.new(event_params)
       
      
        @event = Event.new(event_params)
        client = get_google_calendar_client current_user
        eevent = params[:event]
        event = get_event eevent

        client.insert_event('primary', event)
        flash[:notice] = 'Event was successfully added.'
        @event.save!
        redirect_to events_path
        
    end


      def get_google_calendar_client current_user
        client = Google::Apis::CalendarV3::CalendarService.new
        return unless (current_user.present? && current_user.access_token.present? && current_user.refresh_token.present?)
        secrets = Google::APIClient::ClientSecrets.new({
          "web" => {
            "access_token" => current_user.access_token,
            "refresh_token" => current_user.refresh_token,
            "client_id" => ENV["GOOGLE_CLIENT_ID"],
            "client_secret" => ENV["GOOGLE_CLIENT_SECRET"]
          }
        })
        begin
          client.authorization = secrets.to_authorization
          client.authorization.grant_type = "refresh_token"
    
          if !current_user.present?
            client.authorization.refresh!
            current_user.update_attributes(
              access_token: client.authorization.access_token,
              refresh_token: client.authorization.refresh_token,
              expires_at: client.authorization.expires_at.to_i
            )
          end
        rescue => e
          flash[:error] = 'Your token has been expired. Please login again with google.'
          redirect_to :back
        end
        client
      end

    def show
        @event=Event.find(params[:id])
        
    end

    def get_event event
      
        attendees = event[:members].split(',').map{ |t| {email: t.strip} }
        
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


    
  def event_params
    params.require(:event).permit!
  end

end