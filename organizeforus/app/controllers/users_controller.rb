class UsersController < ApplicationController
  before_action :authenticate_user!

  include Search

  def profile
    @user= User.find(current_user.id)
    @groups=Group.all
    if current_user.access_token?
      dataInizio=parse_datetime(Date.today.to_s, '00:00').to_datetime
      dataFine=parse_datetime( (Date.today + 30).to_s, '00:00').to_datetime
      @event_list =  get_all_events_in_range(current_user, dataInizio, dataFine)
      @event_list=@event_list.items
    end

    

  end
end
