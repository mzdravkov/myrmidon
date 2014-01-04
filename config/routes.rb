Myrmidon::Application.routes.draw do
  devise_for :users
  root to: 'home#index'
  get "home/index"

  resources :tenants, only: [:new, :create, :edit, :show]
  post '/tenants/:id/stop', to: 'tenants#stop'
  post '/tenants/:id/start', to: 'tenants#start'
end
