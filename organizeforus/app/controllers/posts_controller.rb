class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_creator?, only: [:edit, :update, :destroy]
  before_action :correct_user?


  def index
    @group=Group.find(params[:group_id])
    @posts= @group.posts
    @post=Post.new
  end
  def new

  end

  def update
    @post=Post.find(params[:id])
    respond_to do |format|
      if @post.update(post_update_params)
        format.html { redirect_to group_post_url(@post.group,@post), notice: "Post was successfully updated." }
        format.json { head :no_content }
      else
        format.html { redirect_to group_post_url(@post.group,@post), notice: "Not Possible to update." }
        format.json { head :no_content }
      end
    end

  end 

  def show
    @post=Post.find(params[:id])
    @group=Group.find(params[:group_id])
    @comment=Comment.new
    mark_notification_as_read
  end

  def create
    @group=Group.find(params[:group_id])
    @post=@group.posts.build(post_param)
    respond_to do |format|
    if @post.save
      @members=@group.list_accepted
        if !@members.empty?
          @members.each{ |m|
            notify_recipent(@post,@group,m.user)
          }
        end
      format.html { redirect_to group_post_url(@group,@post), notice: "Post created" } 
      format.json { head :no_content }
    else
      format.html { redirect_to group_posts_url(@group), notice: "Not possibile to create post" }
      format.json { render json: @group.errors, status: :unprocessable_entity }
    end
  end
  end

  def destroy
    @group=Group.find(params[:group_id])
    @post=Post.find(params[:id])
    respond_to do |format|
    if @post.destroy
      format.html { redirect_to group_posts_url(@group), notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    else
      format.html { redirect_to group_posts_url(@group), notice: "Post was not successfully destroyed." }
      format.json { head :no_content }
    end
  end
  end

  def is_creator?
    @post=Post.find(params[:id])
    if current_user!=@post.user
      redirect_to group_posts_url(@post.group), notice: "Not Authorized"
    end
  end

  def correct_user? 
    @group=Group.find(params[:group_id])
    if @group.user != current_user
     if Partecipation.find_by(group_id:@group, user_id: current_user).nil?
         redirect_to root_path, notice: "Not Authorized on this Group"
     end
    end
 end



  private 
  def post_param
    params.require(:post).permit(:title, :body, :user_id, files: [] )
  end

  def notify_recipent(post,group,user)
    NewPostNotification.with(post: post,group: group).deliver_later(user) # creazione notifiche
  end

  def post_update_params
    params.require(:post).permit(:title, :body, :user_id)
  end

  def mark_notification_as_read
    @post=Post.find(params[:id])
    if current_user
      notifications_to_mark_as_read= @post.notifications_as_post.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end

  

end
