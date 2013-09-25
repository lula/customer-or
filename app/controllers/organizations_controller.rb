class OrganizationsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  before_action :new_organization, only: [:create]
  load_and_authorize_resource except: [:create]
  
  # GET /organizations
  # GET /organizations.json
  def index
    @grid = OrganizationsGrid.new(params[:organizations_grid])
    @assets = @grid.assets.page(params[:page])
    
    respond_to do |format|
      format.html
      format.json
      format.csv{ send_data @grid.to_csv }
    end
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
    @customers = @organization.customers.page(params[:customers_page])
    @representatives = @organization.representatives.page(params[:representatives_page])
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)

    respond_to do |format|
      if @organization.save
        format.html { redirect_to organization_url(@organization), notice: 'Organization was successfully created.' }
        format.json { render action: 'show', status: :created, location: @organization }
      else
        format.html { render action: 'new' }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to organization_url(@organization), notice: 'Organization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
    @organization.destroy
    respond_to do |format|
      format.html { redirect_to organizations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:organization).permit(:name, :country, :created_at)
    end
    
    def new_organization
      @organization = Organization.new(organization_params)
    end
    
end
