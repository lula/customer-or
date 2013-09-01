class CustomersGrid
  include Datagrid

  scope do
    Customer
  end

  filter :name, :string do |value| 
    where(name: /#{value}/i)
  end
  
  filter :address_city, :string do |value|
    where(:"addresses.city" => /#{value}/i)
  end

  filter :address_country, :enum, select: ::CountrySelect::COUNTRIES.collect { |k,v| [v, k] } do |value|
    where(:"addresses.country" => value)
  end
  
  filter :representative_is_null, :boolean do |value|
    where(:representative => nil)
  end

  filter :created_at, :date, :range => true

  column :name, 
        order: "name", 
        header: I18n.t(:city, scope: [:mongoid, :attributes, :customer], default: "Name"), html: true do |customer|
    link_to customer.name, customer_path(customer)
  end

  column :address_city,
    header: I18n.t(:city, scope: [:mongoid, :attributes, :address], default: "City") do 
      self.main_address.city
  end
  
  column :address_country,
    header: I18n.t(:country, scope: [:mongoid, :attributes, :address], default: "Country") do 
      ::CountrySelect::COUNTRIES[self.main_address.country]
  end
end
