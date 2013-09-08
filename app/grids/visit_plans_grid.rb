class VisitPlansGrid
  include Datagrid

  scope do
    VisitPlan
  end

  filter :user, :enum, select: User.all.map { |c| [c.email, c.id] }, header: I18n.t("datagrid.filters.visit_plan.user", default: "User")
  filter :created_at, :date, :range => true
  
  column :start_date  do |visit_plan|
    visit_plan.start_date.to_date
  end
  column :end_date  do |visit_plan|
    visit_plan.end_date.to_date
  end
  column :comment
  column :user do |visit_plan|
    visit_plan.user
  end
  column :admin do |visit_plan|
    visit_plan.admin.email
  end
  
  column(:created_at) do |visit_plan|
    visit_plan.created_at.to_date
  end
end
