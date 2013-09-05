class VisitPlansController < ApplicationController
  def new
  end
  
  def create    
    options = params[:visit_plan]
    @visits = []
    @errors = []
    customers = Customer.find(options[:customer_ids])
    customers.each do |customer|
      if customer.business_hours.empty?
         error = ActiveModel::Errors.new(self) 
         error.add(:business_hours, t("mongoid.errors.visit_plan.customer.no_business_hours", customer: customer.name, default: "No business hours found for #{customer.name}"))
         @errors << error
        break
      end
      start_date = Date.parse(options[:start_date])
      end_date = Date.parse(options[:end_date])
      
      (start_date..end_date).each do |date|
        customer.business_hours.each do |bh|
          if bh.occurs_on? date
            visit = Visit.new(description: "planned visit", vdate: date, representative: customer.representative, customer: customer)
            if visit.save
              @visits << visit
              break
            else
              @errors << visit.errors
            end
          end
        end
      end
    end
    
    @visits = Kaminari.paginate_array(@visits).page(params[:page])
    render :show 

  end
  
end
