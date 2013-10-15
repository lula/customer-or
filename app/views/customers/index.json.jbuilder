json.array!(@customers) do |customer|
  json.id customer.id.to_s
  json.extract! customer, :name, :valid_from, :valid_to, :created_at
  json.url customer_url(customer, format: :json)
  
  json.address do
    json.id customer.address.id.to_s
    json.extract! customer.address, :street, :city, :country, :telephone
    json.housenr customer.address.house_nr
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