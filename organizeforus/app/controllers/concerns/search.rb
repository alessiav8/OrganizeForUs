require "google/apis/calendar_v3"
require "google/api_client/client_secrets.rb"

module Search

    include ActiveSupport::Concern

    
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


    def get_all_events(user)
        client = get_google_calendar_client user
        @events_list = client.list_events('primary')
        @events_list
    end

  def get_all_events_in_range(user , TimeMax , TimeMin)
    client = get_google_calendar_client user 
    events_list = client.list_evets('primary', timeMax: TimeMax, timeMin: TimeMin)
    events_list
  end

    def find_busiest_person group
        members_list = group.users
        max = 0
        busiest_member = nil
        members_list.each do |member| 
            if member.provider = 'google_oauth2'
                events_list = get_all_events(member)
                n_of_events = events_list.length()
                if max < n_of_events
                    max = n_of_events
                    busiest_member = member
                end
            end
        end 
        busiest_member
    end

#      def search_time_slot(group,TimeMax , TimeMin) 
#     
#       members_list = group.users
#       n_members = members_list.length()
#       c = 0
#        members_list.each do |member|
#          if member.provider = 'google_oauth2'
#            busy = get_all_events_in_range(member, TimeMax, TimeMin)
#            if busy.nil?
#              c = c+1
#            end
#        end
#      
#     end

    def add_time(starting_time , duration)
      new_time = starting_time 
    end


end