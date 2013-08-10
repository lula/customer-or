json.array!(@customers) do |customer|
  json.extract! customer, :name, :valid_from, :valid_to, :created_at
  json.url customer_url(customer, format: :json)
end