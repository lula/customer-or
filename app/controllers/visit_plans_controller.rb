class VisitPlansController < ApplicationController
  
  before_action :visit_plan, only: [:show]
  
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
         @visit_plan.errors.add(:base, t("mongoid.errors.visit_plan.customer.no_business_hours", customer: ActionController::Base.helpers.link_to(customer.name, customer_path(customer)), default: "No business hours found for #{customer.name}"))
        break
      end

      (@visit_plan.start_date..@visit_plan.end_date).each do |date|
        customer.business_hours.each do |bh|
          if bh.occurs_on? date
            visit = Visit.new(description: "planned visit", vdate: date, representative: customer.representative, customer: customer)
            if visit.save
              @visit_plan.visits << visit
              break
            else
              visit.errors.messages.each do |err|
                @visit_plan.errors.add(:visits, err.second.join(","))
              end
            end
          end
        end
      end
    end
    
    @visits = @visit_plan.visits.page(params[:page])
    
    respond_to do |format|
      if @visit_plan.visits.empty?
        # flash[:notice] = "No visit created"
        format.html { render action: :new }
        format.json { render json: @visit_plan.errors, status: :unprocessable_entity }
      elsif @visit_plan.save        
        notice = @visit_plan.errors.empty? ? 'Visit Plan was successfully created.' : 'Please check the below '

        format.html { redirect_to @visit_plan, notice: notice }
        format.json { render action: :show, status: :created, location: @visit_plan }
      else
        format.html { render action: :new }
        format.json { render json: @visit_plan.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def visit_plan
    @visit_plan = VisitPlan.find(params[:id])
    @visits = @visit_plan.visits.page(params[:page])
  end
  
  def visit_plans_params
    params.require(:visit_plan).permit(:start_date, :end_date, :comment, :created_at, customer_ids: [])
  end
  
end
