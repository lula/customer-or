class AddressesController < ApplicationController
  before_action :get_addressable
  before_action :new_address, only: [:create]
  load_and_authorize_resource
  
  def new
    @address = @addressable.addresses.build
  end
  
  def edit
    @address = @addressable.addresses.find(params[:id])
  end
  
  def show
    @address = @addressable.addresses.find(params[:id])
  end
  
  def create
    @address = @addressable.addresses.build(address_params)
    respond_to do |format|
      if @address.save
        format.html { redirect_to edit_polymorphic_path(@addressable), notice: 'Address was successfully created.' }
        format.json { render action: 'show', status: :created, location: @customer }
      else
        format.html { render action: 'new' }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @address = @addressable.addresses.find(params[:id])
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to edit_polymorphic_path(@addressable), notice: 'Address was successfully updated.' }
        format.json { render action: 'show', status: :created, location: @customer }
      else
        format.html { render action: 'edit' }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @address = @addressable.addresses.find(params[:id])
    @address.destroy
    respond_to do |format|
      format.html { redirect_to edit_polymorphic_path(@addressable) }
      format.json { head :no_content }
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def get_addressable
      @addressable = Customer.find(params[:customer_id])
    end
    
    def address_params
      params.require(:address).permit(:id, :street, :house_nr, :city, :country, :description, :main, :telephone)
    end
  
    def new_address
      @address = Address.new(params[address_params])
    end
    
end