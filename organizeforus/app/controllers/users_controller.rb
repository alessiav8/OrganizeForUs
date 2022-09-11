class UsersController < ApplicationController
  before_action :authenticate_user!

  include Search

  def profile
    @user= User.find(current_user.id)
    @groups=Group.where(user_id: @current_user)
    if current_user.access_token?
      dataI=(Date.today - 31 ).to_s
      dataF=(Date.today).to_s
      hI="08:00:00"
      hF="18:00:00"
      datetimeI = parse_datetime(dataI , hI).to_datetime
      datetimeF = parse_datetime(dataF , hF).to_datetime
      @event_list = get_all_events_in_range(current_user , datetimeF , datetimeI)
      puts @event_list
      @event_list=@event_list.items
    end

  end
end
