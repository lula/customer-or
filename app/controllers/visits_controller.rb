class VisitsController < ApplicationController
  before_action :set_visit, only: [:show, :edit, :update, :destroy]
  before_action :new_visit, only: [:create]
  load_and_authorize_resource
  
  # GET /visits
  # GET /visits.json
  def index      
    @grid = VisitsGrid.new(params[:visits_grid])
    @assets = @grid.assets.page(params[:page])
  end
  

  # GET /visits/1
  # GET /visits/1.json
  def show
  end

  # GET /visits/new
  def new
    if params[:customer_id]
      @customer = Customer.find(params[:customer_id])
      @visit = @customer.visits.new
    elsif params[:representative_id]
      @representative = Representative.find(params[:representative_id])
      @visit = @representative.visits.new
    else
      @visit = Visit.new
    end
    
    select_options
  end

  # GET /visits/1/edit
  def edit
    select_options
  end

  # POST /visits
  # POST /visits.json
  def create
    @visit = Visit.new(visit_params)    
    respond_to do |format|
      if @visit.save
        format.html { redirect_to @visit, notice: 'Visit was successfully created.' }
        format.json { render action: 'show', status: :created, location: @visit }
      else
        select_options
        format.html { render action: 'new' }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /visits/1
  # PATCH/PUT /visits/1.json
  def update
    respond_to do |format|
      if @visit.update(visit_params)
        format.html { redirect_to @visit, notice: 'Visit was successfully updated.' }
        format.json { head :no_content }
      else
        select_options
        format.html { render action: 'edit' }
        format.json { render json: @visit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /visits/1
  # DELETE /visits/1.json
  def destroy
    @visit.destroy
    respond_to do |format|
      format.html { redirect_to visits_url }
      format.json { head :no_content }
    end
  end

  def toolbar_actions
    if params[:delete_selected]
      visits = Visit.in(id: params[:selected])
      visits.delete_all
      redirect_to visits_path, notice: I18n.t("mongoid.messages.delete.ok", default: 'Objects deleted succesfully', object_name: I18n.t("mongoid.models.visit", count: 2, default: "Visits"))
    elsif params[:delete_all]
      Visit.delete_all
      redirect_to visits_path, notice: I18n.t("mongoid.messages.delete.ok", default: 'Objects deleted succesfully', object_name: I18n.t("mongoid.models.visit", count: 2, default: "Visits"))
    end 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_visit
      @visit = Visit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def visit_params
      params.require(:visit).permit(:description, :vdate, :comment, :customer_id, :representative_id, :status)
    end
    
    def new_visit
      @visit = Visit.new(visit_params)
    end
    
    def select_options
      if current_user.admin?
        @customers = Customer.all
        @representatives = Representative.all
      elsif current_user.representative
        @customers = Customer.where(representative: current_user.representative)
        @representatives = Representative.in(id: current_user.representative)
      else
        @customers = Customer.in(organization_ids: current_user.organizations.inject([]){|arr,obj| arr << obj.id})
        @representatives = Representative.in(organization_ids: current_user.organizations.inject([]){|arr,obj| arr << obj.id})
      end
    end
end
