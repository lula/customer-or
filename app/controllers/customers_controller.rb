class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :new_customer, only: [:create]
  load_and_authorize_resource
  
  # GET /customers
  # GET /customers.json
  def index
    @grid = CustomersGrid.new(params[:customers_grid])
    if user_signed_in?
      # A User can only see customers belonging to his organizations
      @grid.scope do
        Customer.in(organization_ids: current_user.representative.organizations.inject([]){|arr,org| arr << org.id})
      end
    end

    @assets = @grid.assets.page(params[:page])
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    retrieve_relationships
  end

  # GET /customers/new
  def new
    @customer = Customer.new
    @address = @customer.build_address
  end

  # GET /customers/1/edit
  def edit
    retrieve_relationships
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)
    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: 'Customer was successfully created.' }
        format.json { render action: 'show', status: :created, location: @customer }
      else
        format.html { render action: 'new' }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:name, :valid_from, :valid_to, :created_at, :representative_id, address: [ :_id, :street, :house_nr, :city, :country, :description, :main], organization_ids: [])
    end
    
    def new_customer
      @customer = Customer.new(params[customer_params])
    end
    
    def retrieve_relationships
      @visits_grid = VisitsGrid.new(params[:visits_grid]) { @customer.visits }
      @addresses_grid = AddressesGrid.new(params[:addresses_grid]) do
        if params[:addresses_grid]
          @customer.addresses
        else
          @customer.addresses.asc(:main)
        end
       end
      @business_hours_grid = BusinessHoursGrid.new(params[:business_hours_grid]) { @customer.business_hours }
      
      @organizations_grid = OrganizationsGrid.new(params[:organizations_grid]) do |scope|
        @customer.organizations
      end
    
      @addresses = @addresses_grid.assets.page(params[:addresses_page]).per(1)
      @business_hours = @business_hours_grid.assets.page(params[:business_hours_page]).per(3)
      @visits = @visits_grid.assets.page(params[:visits_page]).per(3)
      @organizations = @organizations_grid.assets.page(params[:organizations_page]).per(3)
    end
end
