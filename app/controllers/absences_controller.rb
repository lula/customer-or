class AbsencesController < ApplicationController
  before_action :set_absence, only: [:show, :edit, :update]
  load_and_authorize_resource except: [:new, :create]
  
  def index
    month = (params[:month] || Time.zone.now.month).to_i
    year = (params[:year] || Time.zone.now.year).to_i

    start_at = Date.civil(year, month ,1)
    end_at = Date.civil(year, month, -1)
    @absences = Absence.all#between(starts_at, ends_at)

    select_options
    
    respond_to do |format|
      format.html
      format.json
      # format.js { render :json => @events }
    end
  end
  
  def new
    @absence = Absence.new()
    @absence.starts_at = params[:starts_at]
    @absence.ends_at = params[:ends_at]
    select_options
  end
  
  def edit
    select_options
  end
  
  def show
    
  end
  
  #-- POST /customers
  # POST /customers.json
  def create
    @absence = Absence.new(absence_params)

    respond_to do |format|
      if @absence.save
        format.html { redirect_to absences_path, notice: 'Absence was successfully created.' }
        format.json { render action: 'index', status: :created }
      else
        select_options
        format.html { render action: 'new' }
        format.json { render json: @absence.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #-- PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @absence.update(absence_params)
        format.html { redirect_to absences_path, notice: 'Absence was successfully updated.' }
        format.json { head :no_content }
      else
        select_options
        format.html { render action: 'edit' }
        format.json { render json: @absence.errors, status: :unprocessable_entity }
      end
    end
  end

  #-- DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @absence.destroy
    respond_to do |format|
      format.html { redirect_to absences_url }
      format.json { head :no_content }
    end
  end
  
  private
    # Retrieves the customer from the database
    #-- Use callbacks to share common setup or constraints between actions.
    def set_absence
      @absence = Absence.find(params[:id])
    end

    # Params white list.
    #-- Never trust parameters from the scary internet, only allow the white list through.
    def absence_params
      params.require(:absence).permit(:starts_at, :ends_at, :reason, :representative_id, :all_day)
    end
    
    def select_options
      if current_user.admin?
        @representatives = Representative.all
      elsif current_user.representative
        @representatives = Representative.where(id: current_user.representative)
      else
        @representatives = Representative.in(organization_ids: current_user.organizations.inject([]){|arr,obj| arr << obj.id})
      end
    end
end
