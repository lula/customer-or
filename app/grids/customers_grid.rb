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
  
  filter :representative_assigned, :eboolean, header: I18n.t("views.grids.customer.representative_assigned", default: "Rep. assigned") do |value|
    if value == 'YES'
      where(:representative.ne => nil)
    elsif value == 'NO'
      where(:representative => nil)
    end
  end

  filter :business_hours_exist, :eboolean do |value|
    where(:business_hours.exists => value)
  end
  
  filter :with_business_hours, :boolean do |value|
    where(:business_hours.exists => true)
  end

  filter :created_at, :date, :range => true
  
  column_names_filter
  
  column :name, header: I18n.t(:city, scope: [:mongoid, :attributes, :customer], default: "Name"), html: true do |customer|
    link_to customer.name, customer_path(customer)
  end

  column :address_city, order: "address.city",
    header: I18n.t(:city, scope: [:mongoid, :attributes, :address], default: "City") do 
      self.address.city
  end
  
  column :address_country,
    header: I18n.t(:country, scope: [:mongoid, :attributes, :address], default: "Country") do 
      ::CountrySelect::COUNTRIES[self.address.country]
  end
end
