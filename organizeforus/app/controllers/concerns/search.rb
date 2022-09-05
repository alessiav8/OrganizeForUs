require "google/apis/calendar_v3"
require "google/api_client/client_secrets.rb"

module Search

    include ActiveSupport::Concern

    
    def get_google_calendar_client current_user
      client = Google::Apis::CalendarV3::CalendarService.new
      return unless (current_user.present? && User.token!(current_user).present? && current_user.refresh_token.present?)

      secrets = Google::APIClient::ClientSecrets.new({
        "web" => {
          "access_token" => User.token!(current_user),
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
            expires_at: getExpirationTime(client.authorization.expires_at)
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
    events_list = client.list_events('primary', time_max: tmax, time_min: tmin , single_events: true , order_by: "startTime")
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

      def compute_total_hours(slots)
        t_minutes = 0
        slots.each do |day|
          slots.each do |slot|
            start_to_minutes = slot.first.first.hour * 60
            end_to_minutes = slot.first.second.hour * 60
            t_minutes += (end_to_minutes - start_to_minutes) + (slot.first.second.minute - slot.first.first.minute)
          end
        end
        hours = t_minutes / 60
        hours.to_i 
        minutes = t_minutes % 60
        tt_minutes = hours.to_s+":"+minutes.to_s
        return tt_minutes
      end

    def organize_for_us(group , dataI , dataF , hI , hF , duration)
      slots = search_slots(group , dataI , dataF , hI , hF , duration)
      merged_slots = merge_slots(slots.clone , hI , hF , duration)
      byebug
    end

    def organize_for_us(group , dataI , dataF , hI , hF , duration)
      t_slots = []
      merged_t_slots = []
      dataR = dataI 
        while dataR <= dataF
          #byebug
          t_slots << search_slots(group , dataR , dataR , hI , hF , duration)
          merged_t_slots << merge_slots(t_slots.last , hI , hF , duration)
          dataR = add_time(dataR.to_datetime , 1440)
          dataR = dataR.strftime("%Y-%m-%d")
          logger.debug dataR
      end
      merged_t_slots.each do |day|
        day.each do |slot|
          if ((slot.second.hour * 60)+slot.second.minute) - ((slot.first.hour * 60)+slot.first.minute) < duration
          day.remove(slot)
          end
        end
      end 
      #byebug
      ore = compute_total_hours(merged_t_slots)
      #debugger.log ore
      merged_t_slots
    end



    def add_time(starting_time , duration=30)
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
    if data.class == DateTime
      data.to_s
    end
    logger.debug data
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
    @flag = 0
    members.each do |member|

      datetimeI = parse_datetime(dataI , hI).to_datetime
      datetimeF = parse_datetime(dataF , hF).to_datetime
      events = get_all_events_in_range(member , datetimeF , datetimeI)
      if events.items.empty? 
        slots[member.id] = [[datetimeI , datetimeF]]
        next
      end
      @flag = 1
      slots[member.id] = []
      events.items.each do |event|
        if event.start.date_time < datetimeI
          datetimeI = event.end.date_time
        else
            if add_time(datetimeI , duration) <= event.start.date_time
                slots[member.id] << [datetimeI,event.start.date_time]
            end
        end
      end
      
      if events.items.last.end.date_time < datetimeF && add_time(events.items.last.end.date_time , duration) < datetimeF
          slots[member.id] << [events.items.last.end.date_time,datetimeF]
      end
    end
    byebug
   slots
   end

   def merge_slots(slots,  hI , hF , duration)
    byebug
    if slots.empty? && @flag == 1
      #Nessuno ha tempo libero
      return nil
    elsif slots.empty? && @flag == 0
      #Nessuno ha eventi
      return []
    end

    res = slots.first.second.clone            #risultato iniziale posto agli slot liberi del primo membro
    slots.delete(slots.keys.first)            #eliminazione del primo membro dai membri da controllare
    while !slots.empty?
      if slots.first.second.empty?             #Il prossimo membro da controllare è sempre impegnato
        res = []                               #Non vi sono dunque slot coincidenti
        return res                             #L'algoritmo termina restituendo l'insieme vuoto
      end

      tmp = []
      while res.length > 0 && slots.first.second.length > 0       #scannerizza tutti gli slot del primo membro e li confronta con quelli nel res
        
        iS = slots.first.second.first.first                       #inizio del primo slot nella lista di slot del primo membro
        fS = slots.first.second.first.second                      #fine del primo slot nella lista di slot del primo membro
        iR = res.first.first                                      #inizio del primo slot nella lista di slot risultato
        fR = res.first.second                                     #fine del primo slot nella lista di slot risultato

        if fR <= iS                                               #se la fine del primo slot di res succede prima dell'inizio del primo slot del primo membro
          res.delete_at(0)                                          #eliminare il primo slot di res
        elsif fS <= iR                                            #se invece la fine del primo slot del primo membro succede prima dell'inizio del primo di res
          slots.first.second.delete_at(0)                           #eliminare il primo slot del primo membro
        else                                                      #altrimenti
          if iR <= iS                                               #se l'inizio del primo slot di res succede prima o come l'inizio del primo slot del primo membro
            if fR <= fS                                               #e se la fine del primo slot di res succede prima della fine del primo slot del primo membro
              if add_time(iS) <= fR                                     #e se lo slot trovato e di dimensione minima a quella di default (30 in questo caso)
                tmp << [iS.clone, fR.clone]                               #salvare lo slot trovato in tmp
              end
              slots.first.second.first[0] = fR.clone                    #impostare l'orario di inizio del primo slot del primo membro a quello di fine del primo slot di res
              res.delete_at(0)                                          #eliminare il primo slot di res
            else                                                      #altrimenti
              if add_time(iS) <= fS                                     #e se lo slot trovato e di dimensione minima a quella di default (30 in questo caso)
                tmp << [iS.clone, fS.clone]                               #salvare lo slot trovato in tmp
              end
              res.first[0] = fS.clone                                   #cambiare l'inizio del primo slot di res con la fine del primo slot del primo membro
              slots.first.second.delete_at(0)                           #eliminare il primo slot del primo membro
            end
          else                                                      #altrimenti (se l'inizio del primo slot di res succede dopo l'inizio del primo slot del primo membro)
            if fR <= fS                                               #e se la fine del primo slot di res succede prima della fine del primo slot del primo membro
              if add_time(iR) <= fR                                     #e se lo slot trovato e di dimensione minima a quella di default (30 in questo caso)
                tmp << [iR.clone, fR.clone]                               #salvare lo slot trovato in tmp
              end
              slots.first.second.first[0] = fR.clone                    #impostare l'orario di inizio del primo slot del primo membro a quello di fine del primo slot di res
              res.delete_at(0)                                          #eliminare il primo slot di res
            else                                                      #altrimenti
              if add_time(iR) <= fS                                     #e se lo slot trovato e di dimensione minima a quella di default (30 in questo caso)
                tmp << [iR.clone, fS.clone]                               #salvare lo slot trovato in tmp
              end
              res.first[0] = fS.clone                                   #cambiare l'inizio del primo slot di res con la fine del primo slot del primo membro
              slots.first.second.delete_at(0)                           #eliminare il primo slot del primo membro
            end
          end
        end
      end
      
      res = tmp                                                   #res uguale agli slot trovati nell'ultimo confronto tra res ed il primo membro della lista da controllare
      slots.delete(slots.keys.first)                              #eliminazione del primo membro dai membri da controllare
    end
    byebug
    res = res.uniq
    return res
    end
end

=begin

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  
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
      byebug
      if events.nil? 
        continue 
      end
      @flag = 1
      slots[member.id] = []
      events.items.each do |event|
        if event.start.date_time < datetimeI
          if datetimeI < event.end.date_time
            datetimeI = event.end.date_time
          end
        else
            if add_time(datetimeI , duration) <= event.start.date_time
              slots[member.id] << [datetimeI,event.start.date_time]
              datetimeI = event.end.date_time
            end
        end
      end
      if add_time(datetimeI , duration) < datetimeF
          slots[member.id] << [datetimeI,datetimeF]
      end
    end
   slots
   end
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
=end