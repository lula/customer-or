class Address
  include Mongoid::Document
  field :street, type: String
  field :house_nr, type: String
  field :city, type: String
  field :country, type: String
  field :description, type: String
  
  embedded_in :customer, inverse_of: "addresses"
  
  validates_presence_of :city
  
  def full_description
    addr = "" 
    addr += "#{self.description}, " if self.description && !self.description.empty?
    addr += "#{self.street}#{" " + self.house_nr if self.house_nr && !self.house_nr.empty?}, " if self.street && !self.street.empty?
    addr += "#{self.city}"
    addr += ", #{self.country}" if self.country && !self.country.empty?
    addr
  end
end
