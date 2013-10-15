class Customer
  include Mongoid::Document

  field :name, type: String
  field :valid_from, type: Date
  field :valid_to, type: Date
  field :created_at, type: Date, default: Time.now
  
  # Indexes
  index({ name: 1 }, { unique: true, name: "name_index" })
  
  embeds_one :address, as: :addressable, cascade_callbacks: true
  embeds_many :alt_addresses, as: :addressable, class_name: "Address", cascade_callbacks: true
  embeds_many :business_hours, cascade_callbacks: true
  has_many :visits
  has_and_belongs_to_many :organizations
  belongs_to :representative
  
  validates_presence_of :name
  
  default_scope order_by(:name.asc)
  
  def addresses
    self.alt_addresses.push(self.address)
  end
      
end