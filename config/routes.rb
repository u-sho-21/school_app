Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :teachers do
    get 'meetings/new', to: 'meetings#new'        # 面談日時登録ページ
    post 'meetings', to: 'meetings#create'        # 面談日時作成
  end

  resources :users

end
