json.array!(@customers) do |customer|
  json.id customer.id.to_s
  json.extract! customer, :name, :valid_from, :valid_to
  json.createdAt customer.created_at
  json.updatedAt customer.updated_at
  json.url customer_url(customer, format: :json)
  
  json.address do
    json.id customer.address.id.to_s
    json.extract! customer.address, :street, :city, :country, :telephone
    json.housenr customer.address.house_nr
  end
  
  json.business_hours do 
    json.array! customer.business_hours do |bh|
      json.id bh.id.to_s
      json.schedule bh.schedule.to_s
      json.extract! bh, :mon, :tue, :thu, :fri, :sat, :sun
    end
  end
  
  json.visits do
    json.array! customer.visits do |visit|
      json.id visit.id.to_s
      json.extract! visit, :vdate, :comment
      json.descr visit.description
      json.status visit.status_text
    end
  end
end