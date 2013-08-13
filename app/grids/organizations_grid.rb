class OrganizationsGrid
  include Datagrid
  
  scope do 
    Organization
  end
  
  filter :name do |value|
    where(name: /#{value}/i)
  end
  
  filter :country, :enum, select: ::CountrySelect::COUNTRIES.collect { |k,v| [v, k] } do |value|
    where(country: value)
  end
  
  column :name
  column :country do 
    ::CountrySelect::COUNTRIES[self.country]
  end
  
end