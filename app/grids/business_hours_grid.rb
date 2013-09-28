class BusinessHoursGrid
  include Datagrid
  
  scope do
    BusinessHour
  end
  
  column_names_filter 
  
  column :schedule do |bh|
    format(bh.schedule) do |value|
      link_to bh.schedule, customer_business_hour_path(bh.customer, bh)
    end
  end
  
  column :mon
  [:mon_start_at, :mon_end_at].each do |time|
    column time do |bh|
      bh.send(time).strftime("%H:%M") if bh.try(time)
    end
  end
  column :tue
  [:tue_start_at, :tue_end_at].each do |time|
    column time do |bh|
      bh.send(time).strftime("%H:%M") if bh.try(time)
    end
  end
  column :wed
  [:wed_start_at, :wed_end_at].each do |time|
    column time do |bh|
      bh.send(time).strftime("%H:%M") if bh.try(time)
    end
  end
  column :thu
  [:thu_start_at, :thu_end_at].each do |time|
    column time do |bh|
      bh.send(time).strftime("%H:%M") if bh.try(time)
    end
  end
  column :fri
  [:fri_start_at, :fri_end_at].each do |time|
    column time do |bh|
      bh.send(time).strftime("%H:%M") if bh.try(time)
    end
  end
  column :sat
  [:sat_start_at, :sat_end_at].each do |time|
    column time do |bh|
      bh.send(time).strftime("%H:%M") if bh.try(time)
    end
  end
  column :sun
  [:sun_start_at, :sun_end_at].each do |time|
    column time do |bh|
      bh.send(time).strftime("%H:%M") if bh.try(time)
    end
  end
 
  
end