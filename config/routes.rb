Rails.application.routes.draw do
  devise_for :users

  root to: 'application#welcome'

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      get 'welcome', to: 'base#welcome'
      post 'auth/token'
      post 'auth/revoke'

      resources :works
      resources :claims, only: :index
      resources :sd_requests, only: :create
      resources :dept821, only: :create
      resources :events, only: :create
      resources :users, only: :index
    end
  end
end
