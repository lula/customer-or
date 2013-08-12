class Organization
  include Mongoid::Document

  field :name, type: String
  field :country, type: String
  field :created_at, type: Date
  
  has_and_belongs_to_many :customers
  has_and_belongs_to_many :representatives
  
  default_scope order_by(:name.asc)
  
end
