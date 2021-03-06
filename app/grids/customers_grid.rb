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

  filter :address_country, :enum, select: Country.all.collect { |k,v| [k, v] } do |value|
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
    
  column :name, header: I18n.t(:city, scope: [:mongoid, :attributes, :customer], default: "Name") do |customer|
    format(customer.name) do |value|
      link_to customer.name, customer_path(customer)
    end
  end

  column :address_city, order: "address.city", header: I18n.t(:city, scope: [:mongoid, :attributes, :address], default: "City") do 
      self.address.city if self.address
  end
  
  column :address_country, header: I18n.t(:country, scope: [:mongoid, :attributes, :address], default: "Country") do 
      self.address.country.name if self.address
  end
end
