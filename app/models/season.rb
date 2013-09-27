class Season
  include Mongoid::Document
  
  field :description, type: String
  field :country, type: String
  field :start_on, type: Date
  field :end_on, type: Date

end
