Rails.application.routes.draw do
  resources :users
  resources :events
  resources :account_activations, only: [:edit]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get  '/events/new',  to: 'events#new'
  post '/events/:id/signup', to: 'events#register', as: 'register'
  delete '/events/:id/unregister', to: 'events#unregister', as: 'unregister'
  get 'events/:id/map', to: 'events#map', as: 'map'
  get '/home', to: 'home#index', as: 'home'

  get 'sessions/new'
  get  '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  get    '/profile',   to: 'users#profile'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  get '/search' => 'pages#search', :as => 'search_page'
  get '/search_events', to: 'events#search'
  post '/search_events', to: 'events#search'
  post '/setUserLocation', to: 'users#setUserLocation'
  

  root 'home#index'


end
