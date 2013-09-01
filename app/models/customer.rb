class Customer
  include Mongoid::Document
    
  field :name, type: String
  field :valid_from, type: Date
  field :valid_to, type: Date
  field :created_at, type: Date, default: Time.now

  # Indexes
  index({ name: 1 }, { unique: true, name: "name_index" })

  
  embeds_many :addresses, as: :addressable, cascade_callbacks: true
  embeds_many :business_hours, cascade_callbacks: true
  has_many :visits

  has_and_belongs_to_many :organizations
  
  belongs_to :representative
  
  accepts_nested_attributes_for :addresses

  def main_address
    addresses.each do |addr|
      return addr if addr.main
    end
  end
  
  validates_presence_of :name
  
end
