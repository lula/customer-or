class Representative
  include Mongoid::Document
  include Searchable
  
  field :name, type: String
  
  validates_presence_of :name
  
  embeds_one :address, cascade_callbacks: true
  has_many :visits
  has_and_belongs_to_many :organizations
  
  accepts_nested_attributes_for :address
  
  scope :name_match, ->(name) { where(name: /#{name}/i) }
  scope :addresses_city_match, ->(city) { where(:"address.city" => /#{city}/i) }
  scope :addresses_country_match, ->(country) { where(:"address.country" => /#{country}/i) }
  
end
