class BusinessHour
  include Mongoid::Document
  include IceCube
    
  field :valid_from, type: Date, default: Time.now
  field :valid_to, type: Date
  
  field :mon, type: Boolean
  field :mon_start_at, type: Time
  field :mon_end_at, type: Time
  field :tue, type: Boolean
  field :tue_start_at, type: Time
  field :tue_end_at, type: Time
  field :wed, type: Boolean
  field :wed_start_at, type: Time
  field :wed_end_at, type: Time
  field :thu, type: Boolean
  field :thu_start_at, type: Time
  field :thu_end_at, type: Time
  field :fri, type: Boolean
  field :fri_start_at, type: Time
  field :fri_end_at, type: Time
  field :sat, type: Boolean
  field :sat_start_at, type: Time
  field :sat_end_at, type: Time
  field :sun, type: Boolean
  field :sun_start_at, type: Time
  field :sun_end_at, type: Time
  field :schedule, type: String
  
  field :season_ids, type: Array
  
  validate :validate_hours
  validate :validate_days
  
  validates_presence_of :mon_start_at, :mon_end_at, if: Proc.new { |b| b.mon == "1" }
  validates_presence_of :tue_start_at, :tue_end_at, if: Proc.new { |b| b.tue == "1" }
  validates_presence_of :wed_start_at, :wed_end_at, if: Proc.new { |b| b.wed == "1" }
  validates_presence_of :thu_start_at, :thu_end_at, if: Proc.new { |b| b.thu == "1" }
  validates_presence_of :fri_start_at, :fri_end_at, if: Proc.new { |b| b.fri == "1" }
  validates_presence_of :sat_start_at, :sat_end_at, if: Proc.new { |b| b.sat == "1" }
  validates_presence_of :sun_start_at, :sun_end_at, if: Proc.new { |b| b.sun == "1" }
  
  before_save :set_schedule
  
  embedded_in :customer, inverse_of: "business_hours"
    
  def occurs_on?(date) # date
    return false unless schedule.occurs_on?(date)
    seasons.each do |season|
      return true if season.occurs_on?(date) 
    end
    false
  end
  
  def occurs_at?(time) # time
    schedule.occurs_at?(time)
  end
  
  def schedule
    Schedule.from_hash(set_schedule)
  end
  
  def set_schedule(date=Time.now)
    s = Schedule.new(date) do |sc|
      rule = Rule.weekly
      days.each do |day|
        rule.day(day[:wday])
      end
      sc.add_recurrence_rule rule
    end
    
    self.schedule = s.to_hash
  end

  def mon?
    mon == true || mon == "1" || mon == 1
  end
  
  def tue?
    tue == true || tue == "1" || tue == 1
  end
  
  def wed?
    wed == true || wed == "1" || wed == 1
  end
  
  def thu?
    thu == true || thu == "1" || thu == 1
  end
  
  def fri?
    fri == true || fri == "1" || fri == 1
  end
  
  def sat?
    sat == true || sat == "1" || sat == 1
  end
  
  def sun?
    sun == true || sun == "1" || sun == 1
  end
    
  def seasons
    list = Array.new
    self.season_ids.each do |id|
      list << Season.find(id) unless id.nil? || id.empty?
    end if self.season_ids
    list
  end  
  
  private
  
  def days
    days = []
    days << { wday: 0, start_at: sun_start_at, end_at: sun_end_at } if sun == "1" || sun == true
    days << { wday: 1, start_at: mon_start_at, end_at: mon_end_at } if mon == "1" || mon == true
    days << { wday: 2, start_at: tue_start_at, end_at: tue_end_at } if tue == "1" || tue == true
    days << { wday: 3, start_at: wed_start_at, end_at: wed_end_at } if wed == "1" || wed == true
    days << { wday: 4, start_at: thu_start_at, end_at: thu_end_at } if thu == "1" || thu == true
    days << { wday: 5, start_at: fri_start_at, end_at: fri_end_at } if fri == "1" || fri == true
    days << { wday: 6, start_at: sat_start_at, end_at: sat_end_at } if sat == "1" || sat == true
    days
  end
  
  def validate_hours
    errors_found = false
    [:mon, :tue, :wed, :thu, :fri, :sat, :sun].each do |day|
      if send(day) && !send("#{day.to_s}_end_at").blank? && !send("#{day.to_s}_start_at").blank?
        if send("#{day.to_s}_end_at") < send("#{day.to_s}_start_at")
          errors.add(:"#{day.to_s}_end_at", "must be greater than start time")
          errors.add(day, "")
          errors_found = true
        end
      end
    end    
    errors.add(:general, "") if errors_found
  end
    
  def validate_days
    return unless days.empty?
    [:mon, :tue, :wed, :thu, :fri, :sat, :sun].each do |day|
      errors.add(day, "")
    end
    errors.add(:global_message, "Add at least a day")    
  end
  
end
