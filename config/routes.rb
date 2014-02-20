Timeauction::Application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }

  root "pages#landing"
  get "how-it-works" => "pages#how_it_works", as: :how_it_works
  get "faq" => "pages#faq", as: :faq
  get "rules" => "pages#rules", as: :rules
  get "opportunities" => "pages#opportunities", as: :opportunities
  get "about" => "pages#about", as: :about
  get "email-alerts" => "pages#email_alerts", as: :email_alerts
  get "contact" => "pages#contact", as: :contact
  get "terms-and-conditions" => "pages#terms_and_conditions", as: :terms_and_conditions

  resources :auctions
  get ":username/auctions" => "auctions#user_auctions", as: :user_auctions

  resources :rewards, :only => [:show, :update]
  get "rewards/not_started/:reward_id" => "rewards#not_started", as: :reward_not_started

  resources :subscribers, :only => [:create]

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
