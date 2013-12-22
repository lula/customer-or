class Absence
  include Mongoid::Document
  
  field :starts_at, type: DateTime
  field :ends_at, type: DateTime
  field :all_day, type: Boolean
  field :reason, type: String
  
  scope :between, ->(start_at, end_at){ all(:conditions => [ start_at: start_at..end_at ]) }
  
  belongs_to :representative
  
  validates_presence_of :representative, :starts_at, :ends_at
  
end
