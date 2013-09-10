class VisitPlansGrid
  include Datagrid

  scope do
    VisitPlan
  end

  filter :user, :enum, select: User.all.map { |c| [c.email, c.id] }, header: I18n.t("datagrid.filters.visit_plan.user", default: "User")
  filter :created_at, :date, :range => true
  
  column :start_date, html: true  do |visit_plan|
    link_to visit_plan.start_date.to_date, visit_plan_path(visit_plan)
  end
  column :end_date do |visit_plan|
    visit_plan.end_date.to_date
  end
  column :comments, order: false
  column :user, order: "user.email" do |visit_plan|
    visit_plan.user.email
  end  
  column(:created_at) do |visit_plan|
    visit_plan.created_at.to_date
  end
end
