class Visit
  include Mongoid::Document
  
  STATUSES = [
    [I18n.t("mongoid.attributes.visits.statuses.proposed", default: "Proposed"), :proposed],
    [I18n.t("mongoid.attributes.visits.statuses.planned", default: "Planned"), :planned],
    [I18n.t("mongoid.attributes.visits.statuses.cancelled", default: "Cancelled"), :cancelled],
    [I18n.t("mongoid.attributes.visits.statuses.completed", default: "Completed"), :completed]
  ]
  
  field :description, type: String
  field :vdate, type: Date
  field :comment, type: String
  field :created_at, type: Date, default: Time.now
  field :status, type: String, default: :proposed
  
  belongs_to :customer
  belongs_to :representative
  belongs_to :visit_plan
  
  validates_presence_of :description, :vdate, :customer, :representative
  
  validate :visit_exists
   
  def visit_exists
    return unless [:planned, :proposed].include? self.status.to_sym
    unless Visit.where(
        :id.ne => self.id,
        status: self.status,
        vdate: self.vdate,
        customer: self.customer,
        representative: self.representative
      ).empty?
      errors.add(:base, "#{I18n.t('mongoid.errors.visit.already_exists', default: 'Visit already exists', status: self.status_text.downcase, vdate: self.vdate, customer: ActionController::Base.helpers.link_to(self.customer.name, Rails.application.routes.url_helpers.customer_path(self.customer)))}")
    end
  end
  
  def status_text
    Visit::STATUSES.each do |stat|
      if stat.second == self.status.to_sym
        return stat.first
      end
    end
  end
  
end