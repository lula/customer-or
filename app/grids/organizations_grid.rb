class OrganizationsGrid
  include Datagrid
  
  scope do 
    Organization
  end
  
  column :name
  column :country
  
end