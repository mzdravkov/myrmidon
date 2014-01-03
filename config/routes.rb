Projo::Application.routes.draw do
  root to: "home#index"
  devise_for :users

  resources :tenants, only: [:new, :create, :edit, :update, :show]
  post 'tenants/:id/stop', to: 'tenants#stop'
  resources :plugins, only: [:new, :create]
end
