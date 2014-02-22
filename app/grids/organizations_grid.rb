class OrganizationsGrid
  include Datagrid
  
  scope do 
    Organization
  end
  
  filter :name do |value|
    where(name: /#{value}/i)
  end
  
  filter :country, :enum, select: Country.all.collect { |k,v| [k, v] } do |value|
    where(country: value)
  end
  
  column :name,  url: ->(model) { Rails.application.routes.url_helpers.organization_path(model) }
  column :country do 
    self.country.name
  end
  
end