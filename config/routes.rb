Tickets::Application.routes.draw do
  
  #admin
  namespace :admin do
    resources :users, :tickets, :settings, :footer_pages, :contacts, :languages, :email_templates 
    match 'dashboard' => 'dashboard#index', :as => :dashboard, via: [:get, :post]

    resources :companies do
      collection do
        get :users
      end
    end
  end
  get 'admin' => 'user_sessions#new', :as => :admin
  match '/forgot_password' => 'fronts#forgot_password', :as => :admin_forgot_password, via: [:get, :post]
  match '/change_password' => 'fronts#change_password', :as => :admin_change_password, via: [:get, :post, :patch]
  
  resources :user_sessions
  resources :users, :path => "companies/:sub_domain/users/"
  resources :tags, :path => "companies/:sub_domain/tags/"
  resources :ticket_replies, :path => "companies/:sub_domain/ticket_replies/"
  resources :ticket_notes, :path => "companies/:sub_domain/ticket_notes/"
  resources :ticket_logs, :path => "companies/:sub_domain/ticket_logs/"
  resources :tickets, :path => "companies/:sub_domain/ticket/"
  
  match '/join/us' => 'fronts#join_us', :as => 'join_us', via: [:get, :post, :patch]
  get '/companies/:sub_domain/login' => 'user_sessions#new', :as => :login
  get 'logout' => 'user_sessions#destroy', :as => :logout
  match '/companies/:sub_domain/signup(/:registration_key)' => 'user_sessions#signup', :as => :signup, via: [:get, :post, :patch]
  
  match '/companies/:sub_domain/forgot_password' => 'fronts#forgot_password', :as => :forgot_password, via: [:get, :post]
  match '/companies/:sub_domain/change_password' => 'fronts#change_password', :as => :change_password, via: [:get, :post, :patch]
  
  match 'activate/:activation_key' => 'fronts#user_activation', :as => :activation_link, via: [:get]
  match '/companies/:sub_domain/profile' => 'fronts#profile', :as => :profile, via: [:get, :post, :patch]
  match '/profile' => 'fronts#profile', :as => :admin_profile, via: [:get, :post, :patch]
  match '/companies/:sub_domain/company/profile' => 'fronts#company_profile', :as => :company_profile, via: [:get, :post, :patch]
  get '/companies/:sub_domain' => 'fronts#company_front', :as => :company_front
  get '/companies/:sub_domain/download/:id/:model' => 'fronts#download', :as => :download
    
  match 'contact_us' => 'fronts#contact_us', :as => :contact_us, via: [:get, :post, :patch]
  get '/other/:page_id' => 'fronts#other', :as => :other
  
  # staff routes
  match '/companies/:sub_domain/tickets' => 'staff#tickets', :as => :staff_tickets, via: [:get, :post, :patch]
  get '/companies/:sub_domain/ticket/reply/:id' => 'staff#ticket_reply', :as => :staff_ticket_reply
  post '/companies/:sub_domain/ticket/reply/create' => 'staff#ticket_reply_create', :as => :staff_ticket_reply_create
  match '/companies/:sub_domain/ticket/actions/:id' => 'staff#ticket_actions', :as => :ticket_actions, via: [:get, :post, :patch]
  
  #root
  root 'fronts#dashboard'

end
