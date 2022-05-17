class GrupposController < ApplicationController
  before_action :set_gruppo, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, expect: [:index, :show]

  # GET /gruppos or /gruppos.json
  def index
    @gruppos = Gruppo.all
  end

  # GET /gruppos/1 or /gruppos/1.json
  def show
  end

  # GET /gruppos/new
  def new
    @gruppo = Gruppo.new
  end

  # GET /gruppos/1/edit
  def edit
  end

  # POST /gruppos or /gruppos.json
  def create
    @gruppo = Gruppo.new(gruppo_params)

    respond_to do |format|
      if @gruppo.save
        format.html { redirect_to gruppo_url(@gruppo), notice: "Gruppo was successfully created." }
        format.json { render :show, status: :created, location: @gruppo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gruppo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /gruppos/1 or /gruppos/1.json
  def update
    respond_to do |format|
      if @gruppo.update(gruppo_params)
        format.html { redirect_to gruppo_url(@gruppo), notice: "Gruppo was successfully updated." }
        format.json { render :show, status: :ok, location: @gruppo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gruppo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /gruppos/1 or /gruppos/1.json
  def destroy
    @gruppo.destroy

    respond_to do |format|
      format.html { redirect_to gruppos_url, notice: "Gruppo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gruppo
      @gruppo = Gruppo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def gruppo_params
      params.require(:gruppo).permit(:nome, :descrizione, :user_id)
    end

    def inside 
      @gruppo=Gruppo.find(params[:id])
    end
end
