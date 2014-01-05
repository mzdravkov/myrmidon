Myrmidon::Application.routes.draw do
  get "plugins/new"
  get "plugins/create"
  devise_for :users
  root to: 'home#index'
  get "home/index"

  resources :tenants, only: [:new, :create, :edit, :update, :show]
  post '/tenants/:id/stop', to: 'tenants#stop'
  post '/tenants/:id/start', to: 'tenants#start'
  resources :plugins, only: [:new, :create]
  post '/plugins/:id/stop', to: 'plugins#stop', as: 'plugin_stop'
  post '/plugins/:id/start', to: 'plugins#start', as: 'plugin_start'
end
