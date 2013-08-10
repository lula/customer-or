class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /customers
  # GET /customers.json
  def index
    @search = Customer.search(params[:search])
    @customers = @search.all.page(params[:page]).order_by(:name.asc)
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    @addresses = @customer.addresses.page(params[:page])
    @business_hours = @customer.business_hours.page(params[:bh_page])
  end

  # GET /customers/new
  def new
    @customer = Customer.new
    @address = @customer.addresses.build
  end

  # GET /customers/1/edit
  def edit
    @addresses = @customer.addresses.page(params[:page])
    @business_hours = @customer.business_hours.page(params[:bh_page])
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
      params.require(:customer).permit(:name, :valid_from, :valid_to, :created_at, addresses_attributes: [ :_id, :street, :house_nr, :city, :country, :description ])
    end
end
