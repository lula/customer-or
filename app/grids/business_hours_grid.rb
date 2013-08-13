class BusinessHoursGrid
  include Datagrid
  
  scope do
    BusinessHour
  end
  
  column :schedule
  
end