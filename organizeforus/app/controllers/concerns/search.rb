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

  def get_all_events_in_range(user , tmax , tmin)
    client = get_google_calendar_client user 
    events_list = client.list_events('primary', time_max: tmax, time_min: tmin , single_events: true , order_by: "StartTime")
    events_list
  end

    def find_busiest_person(group , tmax , tmin)
        members_list = group.users
        max = 0
        busiest_member = nil
        members_list.items.each do |member| 
            if member.provider = 'google_oauth2'
                events_list = get_all_events_in_range(member,tmax,tmin)
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
      minutes = starting_time.minute + duration
      hours = starting_time.hour
      while minutes > 59
        hours = hours + 1
        minutes = minutes - 60 
      end
      days = starting_time.day
      while hours > 24
          day = day + 1
          hours = hours - 24
      end
      new_time = DateTime.new(starting_time.year , starting_time.month , days ,hours , minutes , starting_time.second , starting_time.zone)
      new_time
    end

   def parse_datetime(data , h)
    #"2022-08-25T14:48:00+02:00"
    dt = data+"T"+h+"+02:00"
    dt
   end

   def numerify_datetime(hours , minutes)
    ret = hours+(minutes*0.01)
    ret
   end



   def search_slots(group , dataI , dataF , hI , hF , duration)
    slots = Hash.new   
    members = Array.new
    group.partecipations.each do |part|
      members << part.user
    end
    events = nil
    s_n = 0
    datetimeI = nil
    datetimeF = nil
    @flag = 0
    members.each do |member|

      datetimeI = parse_datetime(dataI , hI).to_datetime
      datetimeF = parse_datetime(dataF , hF).to_datetime
      events = get_all_events_in_range(member , datetimeF , datetimeI)
      if events.nil? 
        continue 
      end
      @flag = 1
      slots[member.id] = []
      s_n = 0
      events.items.each do |event|
        if event.start.date_time < datetimeI
          datetimeI = event.end.datetime
        else
            if add_time(datetimeI , duration) < event.start.date_time
                slots[member.id] << [datetimeI,event.start.date_time]
            #[1,0]:inizio , [1,1]:fine
            s_n += 1
            end
          end
          datetimeI = event.end.date_time 
      end
      if events.items.last.end.date_time < datetimeF && add_time(events.items.last.end.date_time , duration) < datetimeF
          slots[member.id] << [events.items.last.end.date_time,datetimeF]
      end
    end
  slots
  merge_slots(slots , hI , hF , duration)
   end

   def merge_slots(slots,  hI , hF , duration)
    res = []
    r = []
    if slots.empty? && flag == 1
      #Nessuno ha tempo libero
      Nil
    elsif slots.empty? && flag == 0
      #Nessuno ha eventi
      []
    end
    slots.keys.each do |user|
      slots.values_at(user).first.each do |slot| 
      r << slot
      end
    end
    len = r.length()
    while len > 1
      r = r.sort_by{|slot| slot.first}
      aa = numerify_datetime(r.first.first.hour , r.first.first.minute)
      bb = numerify_datetime(r.first.second.hour , r.first.second.minute)
      cc = numerify_datetime(r.second.first.hour , r.second.first.minute)
      dd = numerify_datetime(r.second.second.hour , r.second.second.minute)
      if(cc < bb && dd < bb)
        res << [r.second.first,r.second.second]
        r.delete([r.second.first,r.second.second])
        len-=1
      elsif(dd>bb && cc>bb)
        r.delete(r.first)
        len-=1
      elsif(bb>cc && bb<dd)
        res << [r.second.first,r.first.second]
        r.delete([r.first.first,r.first.second])
        len-= 1
      end
     logger.debug aa 
     logger.debug bb 
     logger.debug cc 
     logger.debug dd 
    end
    res = res.uniq
    res
    byebug
    end
    
end

