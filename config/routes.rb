Timeauction::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations" }

  root "pages#landing"
  # get "how-it-works" => "pages#how_it_works", as: :how_it_works
  # get "rules" => "pages#rules", as: :rules

  get "/404" => "errors#error_404"
  get "/500" => "errors#error_500"

  get "faq" => "pages#faq", as: :faq
  get "faq/archive/round_1" => "pages#faq_round_1", as: :faq_round_1
  get "opportunities" => "pages#opportunities", as: :opportunities
  get "about" => "pages#about", as: :about
  get "email-alerts" => "pages#email_alerts", as: :email_alerts
  get "contact" => "pages#contact", as: :contact
  get "terms-and-conditions" => "pages#terms_and_conditions", as: :terms_and_conditions
  get "donors" => "pages#donors", as: :donors
  get "press" => "pages#press", as: :press
  get "press_release" => "pages#press_release", as: :press_release
  get "share" => "pages#share", as: :share
  get "share/:name" => "pages#named_share", as: :named_share
  get "media" => "pages#media", as: :media
  get "testimonials" => "pages#testimonials", as: :testimonials
  get "privacy-and-security" => "pages#privacy_and_security", as: :privacy_and_security
  get "donors_slider" => "pages#donors_slider", as: :donors_slider

  resources :auctions
  # get ":username/auctions" => "auctions#user_auctions", as: :user_auctions

  resources :rewards, :only => [:show, :update]
  get "rewards/not_started/:reward_id" => "rewards#not_started", as: :reward_not_started

  resources :subscribers, :only => [:create]

  get "users/:id" => "users#show", as: :user
  get "users/upgrade_details" => "users#upgrade_details", as: :upgrade_details
  get "users/upgrade" => "users#upgrade", as: :upgrade_account
  get "users/check_user_premium" => "users#check_user_premium", as: :check_user_premium
  post "users/cancel_subscription" => "users#cancel_subscription", as: :cancel_subscription
  post "users/save_about" => "users#save_about", as: :save_about
  post "users/update_credit_card" => "users#update_credit_card", as: :update_credit_card
  delete "users/delete_credit_card" => "users#delete_credit_card", as: :delete_credit_card

  post "roles/save_details" => "roles#save_details", as: :save_role_details

  get "add-karma" => "karmas#add", as: :add_karma
  patch "create-karma" => "karmas#create", as: :create_karma
  resources :karmas do
    get :autocomplete_nonprofit_name, :on => :collection
  end

  resources :donations, :only => [:create]

  resources :hours_entries, :except => [:index, :edit]
  get "verifiers" => "hours_entries#verifiers", as: :verifiers
  post "update_verifiers" => "hours_entries#update_verifiers", as: :update_verifiers
  post "hours_entries/admin_send_verification_email/:hours_entry_id" => "hours_entries#admin_send_verification_email", as: :admin_send_verification_email
  post "hours_entries/admin_send_verified_email/:hours_entry_id" => "hours_entries#admin_send_verified_email", as: :admin_send_verified_email

  resources :bids, :only => [:create]
  get "auctions/:auction_id/:reward_id/bid" => "bids#bid", as: :bid
  post "bids/admin_send_confirmation_email/:id" => "bids#admin_send_confirmation_email", as: :admin_send_confirmation_email
  post "bids/admin_send_waitlist_email/:id" => "bids#admin_send_waitlist_email", as: :admin_send_waitlist_email

  scope "/corporate" do
    get "/" => "corporations#corporate", as: :corporate
    get "overview" => "corporations#overview", as: :corporate_overview
    get "setup-team" => "corporations#setup_team", as: :corporate_setup_team
    get "setup-program" => "corporations#setup_program", as: :corporate_setup_program
    get "setup-training" => "corporations#setup_training", as: :corporate_setup_training
    get "rewards-sourcing" => "corporations#rewards_sourcing", as: :corporate_rewards_sourcing
    get "rewards-creating" => "corporations#rewards_creating", as: :corporate_rewards_creating
    get "process-promoting" => "corporations#process_promoting", as: :corporate_process_promoting
    get "process-registering" => "corporations#process_registering", as: :corporate_process_registering
    get "process-browsing-and-bidding" => "corporations#process_browsing_and_bidding", as: :corporate_process_browsing_and_bidding
    get "process-granting-rewards" => "corporations#process_granting_rewards", as: :corporate_process_granting_rewards
    get "process-celebrating-successes" => "corporations#process_celebrating_successes", as: :corporate_process_celebrating_successes
  end

  resources :programs, :except => [:show]

  match 'switch_user' => 'switch_user#set_current_user', via: [:get, :post] # Wildcard route for switch_user gem


  scope "/organizations" do
    get "select" => "organizations#select", as: :select_organizations
    post "assign_to_user" => "organizations#assign_to_user", as: :assign_to_user
  end
  
  resources :organizations

  get ":organization_url" => "organizations#show", as: :organization_name
end
