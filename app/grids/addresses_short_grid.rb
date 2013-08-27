class AddressesShortGrid
  include Datagrid
  
  scope do
    Address
  end
  
  column :full_description, header: I18n.t("mongoid.models.address", count: 1)
end