Mobmoney::Application.routes.draw do

  match "signup"   => "users#new",    :as => :signup
  match "login"    => "sessions#new", :as => :login
  match "logout"   => "sessions#destroy", :as => "logout"

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)
  match 'admin'        => 'admin#index',              :as => :admin
  match 'admin/users'  => 'admin#users',              :as => :admin_users
  match 'admin/transactions' => 'admin#transactions', :as => :admin_transactions
  match 'admin/login'  => 'admin#login',              :as => :admin_login
  
  match 'transactions' => 'transactions#index', :as => :transactions
  match 'balance'      => 'transactions#balance', :as => :balance
  match 'transfer'     => 'transactions#transfer',:as => :transfer
  match 'transactions/messages' => 'transactions#messages', :as => :transaction_messages
  
  resources :users do
    member do
      post 'delete'
      #post 'user_phones'
    end
    resources :user_phones
  end
  
  resources :sessions do
    collection do
      post 'create_admin'
      get 'error_message'
      #get 'unregistered_number'
      #get 'incorrect_credentials'
    end
  end
  
  resources :transactions do
    collection do
      post 'search'
      get 'search'
    end
  end
  
  resources :interfaces do
    member do
      post 'delete'
    end
  end

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'transactions#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
