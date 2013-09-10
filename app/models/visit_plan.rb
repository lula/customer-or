class VisitPlan
  include Mongoid::Document
  
  field :start_date, type: Date
  field :end_date, type: Date
  field :comments, type: String
  field :created_at, type: Date, default: Time.now
  field :customer_ids, type: Array
  
  belongs_to :user
  has_many :visits
  
end