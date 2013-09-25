class UsersGrid
  include Datagrid

  scope do
    User
  end

  filter :email, :string do |value|
    where(email: /#{value}/i)
  end
  filter :created_at, :date, :range => true
  
  column :name
  column :email, url: ->(user){ Rails.application.routes.url_helpers.edit_admin_user_path(user) }
  column :representative, url: ->(user){ Rails.application.routes.url_helpers.representative_path(user.representative) } do |user|
    user.representative ? user.representative.name : ""    
  end
  column :sign_in_count
  column :last_sign_in_at
  column :failed_attempts
  column :locked_at
  column :created_at do |model|
    model.created_at.to_date
  end
  
end
