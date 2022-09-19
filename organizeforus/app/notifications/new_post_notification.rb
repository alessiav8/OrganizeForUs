
class NewPostNotification < Noticed::Base

  deliver_by :database

  def message
    @group=Group.find(params[:group][:id])
    @post=Post.find(params[:post][:id])
    "#{@post.user.username} created a new post into #{@group.name}"
  end
  #
  def url
    @group=Group.find(params[:group][:id])
    @post=Post.find(params[:post][:id])
    group_post_path(@group,@post)    
  end  

end
