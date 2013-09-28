class VisitPlansController < ApplicationController
  before_action :visit_plan, only: [:show, :export]
  before_action :determine_customers, only: [:new]  
  load_and_authorize_resource except: [:create, :update]
  
  def index
    @grid = VisitPlansGrid.new(params[:visit_plans])
    @assets = @grid.assets.page(params[:page])
    
    respond_to do |format|
      format.html
      format.json
      format.js
      format.csv{ send_data @grid.to_csv }
    end
  end
  
  def new
    @visit_plan = VisitPlan.new
  end
  
  def show
  end
  
  def create
    @visit_plan = VisitPlan.new(visit_plans_params)

    # Add visits for customers
    customers = Customer.find(@visit_plan.customer_ids)
    customers.each do |customer|
      if customer.business_hours.empty?
        @visit_plan.errors.add(:base, t("mongoid.errors.visit_plan.customer.no_business_hours", customer: ActionController::Base.helpers.link_to(customer.name, customer_path(customer), class: "alert-link"), default: "No business hour created for #{customer.name}"))
        next
      end
      
      unless customer.representative
        @visit_plan.errors.add(:base, t("mongoid.errors.visit_plan.customer.no_representative", customer: ActionController::Base.helpers.link_to(customer.name, customer_path(customer), class: "alert-link"), default: "No representative assigned to #{customer.name}"))
        next
      end
      
      (@visit_plan.start_date..@visit_plan.end_date).each do |date|
        customer.business_hours.each do |bh|
          if bh.occurs_on? date
            visit = @visit_plan.visits.build(description: "planned visit", vdate: date, representative: customer.representative, customer: customer)
            unless visit.save
              @visit_plan.visits.delete(visit)
              visit.errors.full_messages.each do |msg|
                @visit_plan.errors.add(:visits, msg)
              end
            end
          end
        end
      end
    end

    respond_to do |format|
      if !@visit_plan.visits.empty? && @visit_plan.save
        @visits = @visit_plan.visits.page(params[:page])
        format.html { redirect_to @visit_plan }
        format.json { render action: :show, status: :created, location: @visit_plan }
      else
        determine_customers
        format.html { render action: :new }
        format.json { render json: @visit_plan.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def toolbar_actions
    if params[:delete_selected]
      visit_plans = VisitPlan.in(id: params[:selected])
      visit_plans.delete_all
      redirect_to visit_plans_path, notice: I18n.t("mongoid.messages.delete.ok", default: 'Objects deleted succesfully', object_name: I18n.t("mongoid.models.visit_plan", count: 2, default: "Visit Plans"))
    elsif params[:delete_all]
      VisitPlan.delete_all
      redirect_to visit_plans_path, notice: I18n.t("mongoid.messages.delete.ok", default: 'Objects deleted succesfully', object_name: I18n.t("mongoid.models.visit_plan", count: 2, default: "Visit Plans"))
    end 
  end
    
  def export
    respond_to do |format|
      grid = VisitsGrid.new{ @visit_plan.visits }
      format.html { }
      format.csv { send_data grid.to_csv }
    end
  end  
  
  private
  
  def visit_plan
    @visit_plan = VisitPlan.find(params[:id])
    @visits = @visit_plan.visits.page(params[:page])
  end
  
  def visit_plans_params
    params.require(:visit_plan).permit(:user, :start_date, :end_date, :comments, :created_at, customer_ids: [])
  end
  
  def determine_customers
    if current_user.admin?
      @customers = Customer.all
    elsif current_user.representative
      @customers = current_user.representative.customers
    else
      @customers = Customer.in(organization_ids: current_user.organizations.inject([]){|arr,org| arr << org.id})
    end
  end
end
