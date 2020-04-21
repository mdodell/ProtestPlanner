Rails.application.routes.draw do
  get 'markers/create'
  get 'markers/show'
  resources :users
  resources :events
  resources :account_activations, only: [:edit]

  get '/home', to: 'events#index', as: 'home'

  get '/events/manage_event/:event_id', to: 'events#manage_event', as: 'manage_event'
  post '/events/:id/signup', to: 'events#register', as: 'register'
  delete '/events/:id/unregister', to: 'events#unregister', as: 'unregister'
  get '/events/:id/map', to: 'events#map', as: 'map'
  get '/events/:id/map/marker', to: 'markers#show', as: 'get_markers'
  post '/events/:id/map/marker', to: 'markers#create', as: 'add_marker'
  get '/browse', to: 'events#browse', as: 'browse'

  get  '/signup',  to: 'users#new'

  get 'sessions/new'
  get    '/apply_organizer',   to: 'users#applyOrganizer'
  get    '/add_organizer', to: 'events#addOrganizer'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  post '/setUserLocation', to: 'users#setUserLocation'

  root 'events#index'
end
