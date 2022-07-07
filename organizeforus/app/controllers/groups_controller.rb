class GroupsController < ApplicationController
  before_action :set_group, only: [ :show, :edit ,:update ,:destroy ]
  before_action :authenticate_user!, expect: [:index, :show]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :delete_incomplete, only: [:index]


  #se l'user non è autenticato non può fare nulla se non le cose specificate nella index e nella show

  # GET /groups or /groups.json
  def index
    @groups = Group.all

  end


  # GET /groups/1 or /groups/1.json
  def show
    @group=Group.find(params[:id])
    if @group.work
      render "work_group_show"
    else
      render "fun_group_show"
    end 
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
    @group=Group.find(params[:id])
    @partecipations=Partecipation.all
    if @group.work
      render "work_group_edit"
    else
      render "fun_group_edit"
    end 
  end


#forse da togliere
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
        format.html { redirect_to new_partecipations_url(@group)}
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

  def delete_role
    @group=Group.find(params[:id])
  end



  def correct_user
    @group= current_user.groups.find_by(id: params[:id])
    redirect_to root_path, notice: "Not Authorized to Edit this Group" if @group.nil?
  end

  def set_created
    @group=Group.find(params[:id])
    var=@group.update(created:"t")
    if var #se il gruppo viene correttamente modificato
      respond_to do |format|
        format.html { redirect_to @group, notice: "Group was successfully created." }
        format.json { head :no_content }
      end
    else #se ci sono errori nella modifica
      @group.destroy
      respond_to do |format|
      format.html { render :edit, status: :unprocessable_entity }
      format.json { render json: @group.errors, status: :unprocessable_entity }
      end 
    end 
  end


  def delete_incomplete
    Group.where(created: "f").destroy_all
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

    def role_params
      params.require(:group).permit(:role)
    end


    def member_update_params
      params.require(:group).permit(:driver)
    end 
    def inside 
      @group=Group.find(params[:id])
    end

end
