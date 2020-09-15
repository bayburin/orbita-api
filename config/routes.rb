Rails.application.routes.draw do
  devise_for :users

  root to: 'claims#index'

  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      get 'welcome', to: 'base#welcome'
      post 'auth/token'
      post 'auth/revoke'

      resources :works
      resources :claims
    end
  end
end
