class RepresentativesController < ApplicationController
  before_action :set_representative, only: [:show, :edit, :update, :destroy]
  before_action :new_representative, only: [:create]
  load_and_authorize_resource except: [:create]
  
  # GET /representatives
  # GET /representatives.json
  def index
    # @search = Representative.search(params[:search])
    # @representatives = @search.all.page(params[:page])    
    @grid = RepresentativesGrid.new(params[:representatives_grid])
    
    unless current_user.admin?
      # A user can only see customers belonging to his organizations
      @grid.scope do
        if current_user.representative
          Representative.where(id: current_user.representative.id)
        else
          Representative.in(organization_ids: current_user.organizations.inject([]){|arr,org| arr << org.id})
        end
      end
    end
    
    @assets = @grid.assets.page(params[:page])
    
    respond_to do |format|
      format.html
      format.json
      format.js
      format.csv{ send_data @grid.to_csv }
    end
    
  end

  # GET /representatives/1
  # GET /representatives/1.json
  def show
    @visits = @representative.visits.page(params[:visits_page])
    @customers = @representative.customers.page(params[:customers_page])
  end

  # GET /representatives/new
  def new
    @representative = Representative.new
    @representative.address = Address.new
  end

  # GET /representatives/1/edit
  def edit
    @representative.address = Address.new unless @representative.address
  end

  # POST /representatives
  # POST /representatives.json
  def create
    @representative = Representative.new(representative_params)

    respond_to do |format|
      if @representative.save
        format.html { redirect_to @representative, notice: 'Representative was successfully created.' }
        format.json { render action: 'show', status: :created, location: @representative }
      else
        format.html { render action: 'new' }
        format.json { render json: @representative.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /representatives/1
  # PATCH/PUT /representatives/1.json
  def update
    respond_to do |format|
      if @representative.update(representative_params)
        format.html { redirect_to @representative, notice: 'Representative was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @representative.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /representatives/1
  # DELETE /representatives/1.json
  def destroy
    @representative.destroy
    respond_to do |format|
      format.html { redirect_to representatives_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_representative
      @representative = Representative.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def representative_params
      params.require(:representative).permit(:name, address: [ :_id, :street, :house_nr, :city, :country, :description], organization_ids: [])
    end
    
    def new_representative
      @representative = Representative.new(params[representative_params])
    end
end
