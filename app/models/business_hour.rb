class BusinessHour
  include Mongoid::Document
  include IceCube
  
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
    schedule.occurs_on?(date)
  end
  
  def occurs_at?(date) # time
    schedule.occurs_at?(date)
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
  
  private
  
  def days
    days = []
    days << { wday: 0, start_at: sun_start_at, end_at: sun_end_at } if sun == "1"
    days << { wday: 1, start_at: mon_start_at, end_at: mon_end_at } if mon == "1"
    days << { wday: 2, start_at: tue_start_at, end_at: tue_end_at } if tue == "1"
    days << { wday: 3, start_at: wed_start_at, end_at: wed_end_at } if wed == "1"
    days << { wday: 4, start_at: thu_start_at, end_at: thu_end_at } if thu == "1"
    days << { wday: 5, start_at: fri_start_at, end_at: fri_end_at } if fri == "1"
    days << { wday: 6, start_at: sat_start_at, end_at: sat_end_at } if sat == "1"
    days
  end
  
  def validate_hours
    [:mon, :tue, :wed, :thu, :fri, :sat, :sun].each do |day|
      if send(day) == "1" && !send("#{day.to_s}_end_at").blank? && !send("#{day.to_s}_start_at").blank?
        if send("#{day.to_s}_end_at") < send("#{day.to_s}_start_at")
          errors.add(:"#{day.to_s}_end_at", "must be greater than start time")
        end
      end
    end
  end
    
  def validate_days
    return unless days.empty?
    errors.add(:bh, "Add at least a day" )
  end

end
