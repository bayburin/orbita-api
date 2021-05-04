# require 'sidekiq/web'
# Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  # mount Sidekiq::Web => '/sidekiq' # mount Sidekiq::Web in your Rails app
  use_doorkeeper
  devise_for :users

  root to: 'application#welcome'

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      get 'welcome', to: 'base#welcome'
      post 'auth/token'
      post 'auth/revoke'

      resources :claims, only: :index
      resources :sd_requests, only: [:index, :create, :update]
      resources :events, only: :create
      resources :users, only: :index
      resources :employees, only: :index
    end
  end

  namespace :guest, constraints: { format: 'json' } do
    namespace :api do
      namespace :v1 do
        get 'welcome', to: 'base#welcome'
        resources :sd_requests, only: :create
        resources :service_desk, only: :create
        resources :events, only: :create
        resources :astraea, only: [:create, :update]
      end
    end
  end
end
