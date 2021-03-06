class BusinessHoursController < ApplicationController
  before_action :set_customer
  before_action :new_business_hour, only: [:create]
  load_and_authorize_resource
  
  def edit
    @business_hour = @customer.business_hours.find(params[:id])
    set_seasons
  end

  def new
    @business_hour = @customer.business_hours.build
    set_seasons
    @business_hour.season_ids = []
    @seasons.each do |season|
      @business_hour.season_ids.push(season[1])
    end
  end

  def show
    @business_hour = @customer.business_hours.find(params[:id])
    @seasons = @business_hour.seasons.reject {|value| value == nil }
  end
  
  def create
    @business_hour = @customer.business_hours.build(business_hours_params)
    respond_to do |format|
      if @business_hour.save
        format.html { redirect_to edit_customer_path(@customer), notice: 'Business Hour was successfully created.' }
        format.json { render action: 'show', status: :created, location: @customer }
      else
        format.html { render action: 'new' }
        format.json { render json: @business_hour.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def update
    @business_hour = @customer.business_hours.find(params[:id])

    respond_to do |format|
      if @business_hour.update(business_hours_params)
        format.html { redirect_to edit_customer_path(@customer), notice: 'Business Hour was successfully updated.' }
        format.json { render action: 'show', status: :created, location: @customer }
      else
        format.html { render action: 'edit' }
        format.json { render json: @business_hour.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @business_hour = @customer.business_hours.find(params[:id])
    @business_hour.destroy
    respond_to do |format|
      format.html { redirect_to edit_customer_path(@customer) }
      format.json { head :no_content }
    end
  end
  
  private 
  
  def business_hours_params
    params.require(:business_hour).permit(
        :mon, :mon_start_at, :mon_end_at,
        :tue, :tue_start_at, :tue_end_at,
        :wed, :wed_start_at, :wed_end_at,
        :thu, :thu_start_at, :thu_end_at,
        :fri, :fri_start_at, :fri_end_at,
        :sat, :sat_start_at, :sat_end_at,
        :sun, :sun_start_at, :sun_end_at,        
        season_ids: [] )
  end
  
  def set_customer
    @customer = Customer.find(params[:customer_id])
  end
  
  def new_business_hour
    @business_hour = BusinessHour.new(params[business_hours_params])
  end
  
  def set_seasons
    seasons = Season.where(country: @business_hour.customer.address.country) 
    if seasons.length == 0
      seasons = Season.where(country: "")
    end
    
    @seasons = seasons.map { |c| [c.description, c.id] }  
  end
end
