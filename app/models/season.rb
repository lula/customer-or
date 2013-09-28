class Season
  include Mongoid::Document
  
  field :description, type: String
  field :country, type: String
  field :start_on, type: Date
  field :end_on, type: Date
  
  def occurs_on?(date)
    
    # Not sure if there's a neater expression. yday is out due to leap years
    date_hash = date.month*100 + date.mday
    start_hash = start_on.month*100 + start_on.mday
    end_hash = end_on.month*100 + end_on.mday
    
    return start_hash > end_hash ? 
      (1231-start_hash..end_hash) === date_hash
      :
      (start_hash..end_hash) === date_hash
    
  end
  
end
