class GroupsController < ApplicationController
  before_action :set_group, only: [ :show, :edit ,:update ,:destroy ]
  before_action :authenticate_user!, expect: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]

  #se l'user non è autenticato non può fare nulla se non le cose specificate nella index e nella show

  # GET /groups or /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1 or /groups/1.json
  def show
  end

  def show_work
  end

  def member_group
  end
  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  def edit_driver
    @group=Group.find(params[:id])
    @member = @group.members.find_by(user_email: member_update_params[:driver])
    @group.members.update(:all, driver: "f")
    @member.update(driver: "t")
    respond_to do |format|
        format.html { redirect_to group_url(@group), notice: "the new designeted driver is: "+ member_update_params[:driver] }  
    end
  end 


  # POST /groups or /groups.json
  def create
    #@group = Group.new(group_params)
    @group=current_user.groups.build(group_params)
    if group_params[:fun]=='1' 
      work_or_fun="Fun" 
    else 
      work_or_fun="Work"
    end 
    
    respond_to do |format|
      if @group.save 
        format.html { redirect_to group_url(@group), notice: work_or_fun+"Group was successfully updated."}
        format.json { render :show, status: :created, location: @group }
         
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1 or /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to group_url(@group), notice: "Group was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1 or /groups/1.json
  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to groups_url, notice: "Group was successfully destroyed." }
      format.json { head :no_content }
    end
  end


  def correct_user
    @group= current_user.groups.find_by(id: params[:id])
    redirect_to root_path, notice: "Not Authorized to Edit this Group" if @group.nil?
  end
 


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.require(:group).permit(:name, :description, :user_id, :fun, :work)
    end

    def member_update_params
      params.require(:group).permit(:driver)
    end 
    def inside 
      @group=Group.find(params[:id])
    end

end
