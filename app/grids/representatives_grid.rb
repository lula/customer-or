class RepresentativesGrid
  include Datagrid

  scope do
    Representative
  end

  filter :name, :string do |value| 
    where(name: /#{value}/i)
  end
  
  filter :address_city, :string do |value|
    where(:"address.city" => /#{value}/i)
  end

  filter :address_country, :enum, select: ::CountrySelect::COUNTRIES.collect { |k,v| [v, k] } do |value|
    where(:"address.country" => value)
  end

  column :name, 
    header: I18n.t(:city, scope: [:mongoid, :attributes, :customer], default: "Name"),
    url: ->(model){ Rails.application.routes.url_helpers.representative_path(model) }
    
  column :address_city, order: "address.city", 
    header: I18n.t(:city, scope: [:mongoid, :attributes, :address], default: "City") do 
      self.address.city
  end
  
  column :address_country, order: "address.country", 
    header: I18n.t(:country, scope: [:mongoid, :attributes, :address], default: "Country") do 
      ::CountrySelect::COUNTRIES[self.address.country]
  end
end
