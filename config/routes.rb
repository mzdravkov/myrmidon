Projo::Application.routes.draw do
  root to: "home#index"
  devise_for :users

  resources :tenants, only: [:new, :create]
end