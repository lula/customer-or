class AddressesShortGrid
  include Datagrid
  
  scope do
    Address
  end
  
  column :full_description, header: I18n.t("mongoid.models.address", count: 1), html: true do |address|
    address.reload
    link_to address.full_description, customer_address_path(address.addressable, address)
  end
end