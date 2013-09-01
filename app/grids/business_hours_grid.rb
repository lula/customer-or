class BusinessHoursGrid
  include Datagrid
  
  scope do
    BusinessHour
  end
  
  column :schedule, html: true do |bh|
    link_to bh.schedule, customer_business_hour_path(bh.customer, bh)
  end
  
end