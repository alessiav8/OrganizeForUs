# To deliver this notification:
#
# NewCommentNotification.with(post: @post).deliver_later(current_user)
# NewCommentNotification.with(post: @post).deliver(current_user)

class NewCommentNotification < Noticed::Base

  deliver_by :database

  def message
    @group=Group.find(params[:group][:id])
    @post=Post.find(params[:post][:id])
    @user=User.find(params[:user][:id])
    "#{@user.username} commented your post #{@post.title} into #{@group.name}"
  end
  #
  def url
    @group=Group.find(params[:group][:id])
    @post=Post.find(params[:post][:id])
    post_show_path(@group,@post)
  end  

end
