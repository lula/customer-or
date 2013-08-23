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
  
  column :name,  url: ->(model) { Rails.application.routes.url_helpers.admin_organization_path(model) }
  column :country do 
    ::CountrySelect::COUNTRIES[self.country]
  end
  
end