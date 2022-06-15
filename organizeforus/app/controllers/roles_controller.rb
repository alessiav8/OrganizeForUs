class RolesController < ApplicationController

    def create
        @group = Group.find(params[:group_id])
        @role = @group.roles.create(comment_params)
        redirect_to group_path(@group)
      end

      def destroy
        @group = Group.find(params[:group_id])
        @role = @group.roles.find(params[:id])
        @role.destroy
        redirect_to group_path(@group)
      end

      private
        def comment_params
          params.require(:role).permit(:tag)
        end
end
