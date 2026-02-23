# SaaS landing page
Rails.application.routes.draw do
  get 'subscriptions/index'
  get 'deadlines/index'
  get 'landing', to: 'home#landing', as: :landing
  get 'features', to: 'home#features', as: :features
  # Route for testing in-app notifications
  get 'notify_test', to: 'home#notify_test'
  # Route for testing email notifications
  get 'email_notify_test', to: 'home#email_notify_test'
  get 'trial_notify_test', to: 'home#trial_notify_test'
  resources :cases, only: %i[new create index show destroy edit update] do
    member do
      get :download_pdf
      post :summarize
      get :download_summary
      post :search_precedents
      post :generate_draft
      get :export_word
    end
  end
  resources :deadlines, only: [:index]
  resources :subscriptions, only: %i[index create]
  extend Authenticator

  # authentification
  get 'sign_in', to: 'sessions#new'
  post 'sign_in', to: 'sessions#create'
  get 'sign_up', to: 'registrations#new'
  post 'sign_up', to: 'registrations#create'

  resources :sessions, only: [:destroy]
  resource :password, only: %i[edit update]

  # Admin-specific login separate from regular user sign-in
  get 'admin/login', to: 'admin/sessions#new', as: :admin_login
  post 'admin/login', to: 'admin/sessions#create'
  delete 'admin/logout', to: 'admin/sessions#destroy', as: :admin_logout
  namespace :admin do
    get 'analytics', to: 'analytics#index'
  end
  namespace :identity do
    resource :email, only: %i[edit update]
    resource :email_verification, only: %i[show create]
    resource :password_reset, only: %i[new edit create update]
  end

  # Mount admin tooling at /admin; Avo will handle authorization via `Current.user`
  mount Avo::Engine, at: Avo.configuration.root_path
  mount Blazer::Engine, at: 'blazer'
  mount SolidErrors::Engine, at: '/solid_errors'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # static pages
  sitepress_pages

  # resources
  resource :dashboard, only: [:show]

  # Optionally, set dashboard as root for authenticated users (pseudo-code, see Devise or custom logic)
  # authenticated :user do
  #   root to: 'dashboards#show', as: :authenticated_root
  # end

  # health check
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', :as => :rails_health_check

  # Defines the root path route ("/")

  root to: 'home#landing'
end
