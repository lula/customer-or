class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy, :export_addresses]
  before_action :new_customer, only: [:create]
    
  load_and_authorize_resource except: [:new]
  
  # GET /customers
  # GET /customers.json
  def index
    @grid = CustomersGrid.new(params[:customers_grid])
    unless current_user.admin?
      # A user can only see customers belonging to his organizations
      @grid.scope do
        if current_user.representative
          Customer.in(id: current_user.representative.customers.inject([]){|arr,obj| arr << obj.id})
        else
          Customer.in(organization_ids: current_user.organizations.inject([]){|arr,obj| arr << obj.id})
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

  # GET /customers/1
  # GET /customers/1.json
  def show
    retrieve_relationships
  end

  # GET /customers/new
  def new
    @customer = Customer.new(representative: current_user.representative)
    @address = @customer.build_address
    select_options
  end

  # GET /customers/1/edit
  def edit
    retrieve_relationships
    select_options
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
        select_options
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
        select_options
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
  
  def import 
    if params[:customers] && params[:customers][:file]
      file = params[:customers][:file]
      begin
        CSV.foreach file.path, headers: true do |row|
          hash = {}
          row.to_hash.each_pair do |k,v|
            hash.merge!({ k.downcase => v })
          end
          
          Customer.create! hash
        end
      rescue Exception => e
        flash[:danger] = "An error occurred while importing customers. Check your file and try again."
      end
    end
  end
  
  def export_addresses
    respond_to do |format|
      grid = AddressesGrid.new{ @customer.addresses }
      format.html
      format.js
      format.csv { send_data grid.to_csv }
    end
  end
  
  def export_business_hours
    respond_to do |format|
      grid = BusinessHoursGrid.new{ @customer.business_hours }
      format.html
      format.js
      format.csv { send_data grid.to_csv }
    end
  end
  
  def export_organizations
    respond_to do |format|
      grid = OrganizationsGrid.new{ @customer.organizations }
      format.html 
      format.js
      format.csv { send_data grid.to_csv }
    end
  end
  
  def toolbar_actions
    if params[:delete_selected]
      objects = Customer.in(id: params[:selected])
      unless objects.empty?
        objects.delete_all
        notice = I18n.t("mongoid.messages.delete.ok", default: 'Objects deleted successfully', object_name: I18n.t("mongoid.models.customer", count: 2, default: "Customers"))
      end
      redirect_to customers_path, notice: notice
    elsif params[:delete_all]
      Customer.delete_all
      redirect_to customers_path, notice: I18n.t("mongoid.messages.delete.ok", default: 'Objects deleted successfully', object_name: I18n.t("mongoid.models.customer", count: 2, default: "Customers"))
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
    
      @addresses = @addresses_grid.assets.page(params[:addresses_page]).per(3)
      @business_hours = @business_hours_grid.assets.page(params[:business_hours_page]).per(3)
      @visits = @visits_grid.assets.page(params[:visits_page]).per(3)
      @organizations = @organizations_grid.assets.page(params[:organizations_page]).per(3)
    end
    
    def select_options
      if current_user.admin?
        @representatives = Representative.all
        @organizations = Organization.all
      elsif current_user.representative
        @representatives = Representative.where(id: current_user.representative)
        @organizations = current_user.representative.organizations
      else
        @representatives = Representative.in(organization_ids: current_user.organizations.inject([]){|arr,obj| arr << obj.id})
        @organizations = Organization.in(id: current_user.organizations.inject([]){|arr,obj| arr << obj.id})
      end
    end
end
