Rails.application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :events
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get  '/events/new',  to: 'events#new'
  root 'home#index'

  get "signup", to: "users#new", as: "signup"
  get "login", to: "sessions#new", as: "login"
  get "logout", to: "sessions#destroy", as: "logout"
end
