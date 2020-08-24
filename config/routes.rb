Rails.application.routes.draw do
  devise_for :users

  root to: 'claims#index'

  resources :works
  resources :claims
end
