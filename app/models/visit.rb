class Visit
  include Mongoid::Document
  
  field :description, type: String
  field :vdate, type: Date
  field :comment, type: String
  field :created_at, type: Date, default: Time.now
  
  belongs_to :customer
  belongs_to :representative
  
  validates_presence_of :description, :vdate, :customer, :representative
  
end