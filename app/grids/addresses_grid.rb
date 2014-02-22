class AddressesGrid
  include Datagrid
  
  scope do
    Address
  end
    
  column :full_description, order: "city", header: I18n.t("mongoid.models.address", count: 1), html: true do |address|
    link_to address.full_description, customer_address_path(address.addressable, address)
  end
  
  column :description
  column :street
  column :house_nr
  column :city
  column :country do
    country.name
  end
  
end