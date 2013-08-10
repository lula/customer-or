class Customer
  include Mongoid::Document
  include Searchable
  
  field :name, type: String
  field :valid_from, type: Date
  field :valid_to, type: Date
  field :created_at, type: Date, default: Time.now
  
  embeds_many :addresses, cascade_callbacks: true
  accepts_nested_attributes_for :addresses
  
  scope :name_match, ->(name) { where(name: /#{name}/i) }
  scope :addresses_city_match, ->(city) { where(:"addresses.city" => /#{city}/i) }
  scope :addresses_country_match, ->(country) { where(:"addresses.country" => /#{country}/i) }
  
  validates_presence_of :name
end
