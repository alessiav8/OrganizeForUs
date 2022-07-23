class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @group=Group.find(params[:group_id])
  end
  def new
  end

end
