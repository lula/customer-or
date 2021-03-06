class Address
  include Mongoid::Document

  field :street, type: String
  field :house_nr, type: String
  field :city, type: String
  field :country, type: Country
  field :description, type: String
  field :main, type: Boolean
  field :telephone, type: String
  
  embedded_in :addressable, polymorphic: true
  
  validates_presence_of :city
  
  def is_main?
    main == "1" || main == true
  end
  
  def addressable!
    self.addressable
  end
  
  def full_description
    addr = "" 
    addr += "#{self.description}, " if self.description && !self.description.empty?
    addr += "#{self.street}#{" " + self.house_nr if self.house_nr && !self.house_nr.empty?}, " if self.street && !self.street.empty?
    addr += "#{self.city}"
    addr += ", #{self.country}" if self.country
    addr
  end
    
  def self.to_csv
    CSV.generate do |csv|
      csv << self.fields.keys
      all.each do |obj|
        csv << obj.attributes.values_at(*fields.keys)
      end
    end
  end
end