Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :users
  resources :events
  resources :account_activations, only: [:edit]

  get '/home', to: 'events#index', as: 'home'

  post '/remove_attendee', to: 'events#remove_attendee', as: 'remove_attendee'

  get '/events/manage_event/:event_id', to: 'events#manage_event', as: 'manage_event'
  post '/events/:id/signup', to: 'events#register', as: 'register'
  delete '/events/:id/unregister', to: 'events#unregister', as: 'unregister'
  get '/events/:id/map', to: 'events#map', as: 'map'
  get '/events/:id/map/marker', to: 'markers#show', as: 'get_markers'
  post '/events/:id/map/marker', to: 'markers#create', as: 'add_marker'
  get '/browse', to: 'events#browse', as: 'browse'
  post '/send_notification', to: 'events#send_notification'
  get'/event_unsubscribe', to: 'events#unsubscribe', as: 'unsubscribe'
  get'/event_subscribe', to: 'events#subscribe', as: 'subscribe'

  get  '/signup',  to: 'users#new'

  get 'sessions/new'
  post    '/apply_organizer',   to: 'users#applyOrganizer'
  get    '/add_organizer', to: 'events#addOrganizer'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  post '/setUserLocation', to: 'users#setUserLocation'

  root 'events#index'
end
