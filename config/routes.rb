Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :teachers do
    get 'meetings/new', to: 'meetings#new'                                    # 面談日時登録ページ
    post 'meetings', to: 'meetings#create'                                    # 面談日作成
    post 'meeting_times', to: 'meeting_times#create'                          # 面談時間作成
    get 'meetings/edit', to: 'meetings#edit'                                  # 面談日時編集・送信ページ
    patch 'meetings/edit', to: 'meetings#update', as: :meetings_update             # 面談日時更新
  end

  resources :users

end
