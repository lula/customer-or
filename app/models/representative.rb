class Representative
  include Mongoid::Document
  
  field :name, type: String
  
  validates_presence_of :name
  
  embeds_one :address, as: :addressable, cascade_callbacks: true
  has_many :visits
  has_and_belongs_to_many :organizations
  has_one :user
  has_many :customers
  
  accepts_nested_attributes_for :address
  
end
