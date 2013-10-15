CustomerOr::Application.routes.draw do
  devise_for :users
  
  devise_scope :user do
    post "api/v1/sessions", to: "api/v1/sessions#create"
  end
  
  # namespace :api do
  #   namespace :v1  do
  #     resources :sessions, :only => [:create, :destroy]
  #   end
  # end
  
  concern :addressable do 
    resources :addresses
  end

  resources :representatives, concerns: :addressable do
    resource :visit, only: [:new]
  end
  
  resources :customers, concerns: :addressable do
    resources :business_hours
    resource :visit, only: [:new]
      
    collection do 
      get "import"
      post "import"
      post "toolbar_actions"
    end
    
    member do 
      get "export_addresses"
      get "export_business_hours"
      get "export_organizations"
    end
    
  end
  
  resources :visits do
    post "toolbar_actions", on: :collection
  end
  
  resources :visit_plans do
    post "toolbar_actions", on: :collection
    member do 
      get "export"
    end
  end

  resources :organizations
  namespace :admin do 
    resources :users
  end
  root to: "home#index"
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
