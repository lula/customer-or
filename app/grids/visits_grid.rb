class VisitsGrid
  include Datagrid

  scope do
    Visit
  end

  filter :description, :string do  |value|
    where(description: Regexp.compile(value))
  end
  filter :vdate, :date, range: true, header: I18n.t("datagrid.filters.visits.vdate", default: "Visit date from/to")
  filter :customers, :enum, select: Customer.all.map { |c| [c.name, c.id] }, multiple: true do |value|
    where(:customer.in => value.reject{ |v| v.blank? })
  end
  filter :status, :enum, select: Visit::STATUSES
  filter :created_at, :date, :range => true
  
  column :description, url: ->(visit) { Rails.application.routes.url_helpers.visit_path(visit) }
  column :vdate
  column :status do |model|
    model.status_text
  end
  column :customer, 
    url: ->(model){ Rails.application.routes.url_helpers.customer_path(model.customer) } do |model| 
    model.customer.name
  end
  column :representative, 
    url: ->(model){ Rails.application.routes.url_helpers.representative_path(model.representative) } do |model| 
    model.representative.name
  end
  
  column(:created_at) do |model|
    model.created_at.to_date
  end
end
