Rails.application.routes.draw do
  devise_for :users
  resources :works
  resources :claims
end
