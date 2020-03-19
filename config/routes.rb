Rails.application.routes.draw do
  resources :users
  resources :events
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get  '/events/new',  to: 'events#new'
  get  '/browse',  to: 'events#index'
  get '/home', to: 'home#index'
  get '/my_events', to: 'users#index'
  post '/signup_for_event' => 'users#signup_for_event'
  root 'home#index'

  get 'sessions/new'
  get  '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  resources :account_activations, only: [:edit]

end
