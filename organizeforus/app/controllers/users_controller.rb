class UsersController < ApplicationController
  before_action :authenticate_user!

  include Search

  def profile
    @user= User.find(current_user.id)

    if current_user.access_token?
      @event_list =  get_all_events(current_user)
      @event_list=@event_list.items
    end

    

  end
end
