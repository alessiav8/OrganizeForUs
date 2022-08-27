class UsersController < ApplicationController
  def profile
    @user= User.find(current_user.id)
    render "users/profile"
  end
end
