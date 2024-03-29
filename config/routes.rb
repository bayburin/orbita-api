# require 'sidekiq/web'
# Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

Rails.application.routes.draw do
  # mount Sidekiq::Web => '/sidekiq' # mount Sidekiq::Web in your Rails app
  use_doorkeeper
  devise_for :users

  root to: 'application#welcome'

  mount ActionCable.server => '/cable'

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      get 'welcome', to: 'base#welcome'
      get 'init', to: 'base#init'
      get 'svt/items', to: 'svt#items'
      get 'svt/find_by_barcode/:barcode', to: 'svt#find_by_barcode'
      get 'auth_center/show_host', to: 'auth_center#show_host'
      get 'auth_center/show_user_hosts', to: 'auth_center#show_user_hosts'
      post 'auth/token'
      post 'auth/revoke'

      resources :claims, only: :index do
        resources :attachments, only: [:show]
        resources :comments, only: [:create]
      end
      resources :sd_requests, only: [:index, :show, :create, :update] do
        resources :parameters, only: [:index]
      end
      resources :events, only: :create
      resources :users, only: :index
      resources :employees, only: [:index, :show]
    end
  end

  namespace :guest, constraints: { format: 'json' } do
    namespace :api do
      namespace :v1 do
        get 'welcome', to: 'base#welcome'
        resources :sd_requests, only: :create
        resources :events, only: :create
        resources :astraea, only: [:create, :update]
      end
    end
  end

  namespace :service_desk, constraints: { format: 'json' } do
    namespace :api do
      namespace :v1 do
        get 'welcome', to: 'base#welcome'
        resources :sd_requests, only: :create
      end
    end
  end
end
