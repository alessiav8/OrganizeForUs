class CommentsController < ApplicationController

    before_action :authenticate_user!


    def create
        #@group = Group.new(group_params)
        @post=Post.find(params[:post_id])
        @comment=@post.comments.build(comment_params)
        respond_to do |format|
          if @comment.save
            notify_recipent(@post, @post.group, current_user)
            format.html { redirect_to group_post_url(@post.group,@post), notice: "Comment generated" }
            format.json { render :show, location: @post, status: :created }             
          else
            format.html { redirect_to group_post_url(@post.group,@post), notice: "Comment not long enough, the minimum is 3 characters" }
            format.json { render json: @comment.errors, status: :unprocessable_entity }
          end
        end

      end


      private
      def comment_params
        params.require(:comment).permit(:text, :user_id)
      end

      def notify_recipent(post,group,user)
        NewCommentNotification.with(post: post,group: group,user:user).deliver_later(post.user) # creazione notifiche
      end
    

end
