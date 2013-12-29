Projo::Application.routes.draw do
  root to: "home#index"
  devise_for :users

  resources :tenants, only: [:new, :create, :edit, :update, :show]
  resources :plugins, only: [:new, :create]
end
