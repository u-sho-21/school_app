Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get 'meetings/new', to: 'meetings#new'

  resources :teachers

  resources :users

end
