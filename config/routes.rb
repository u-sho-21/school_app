Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :teachers do
    get 'meetings/new', to: 'meetings#new'                                                    # 面談日時登録ページ
    post 'meetings', to: 'meetings#create'                                                    # 面談日作成
    post 'meeting_times', to: 'meeting_times#create'                                          # 面談時間作成
    get 'meetings/edit', to: 'meetings#edit'                                                  # 面談日時編集・送信ページ
    patch 'meetings/edit', to: 'meetings#update', as: :meetings_update                        # 面談日時更新
  end

  resources :users do
    get  ':child_id/meetings/new_user', to: 'meetings#new_user', as: :meetings_new_user       # 保護者面談日時登録ページ
    get  ':child_id/meetings/desired', to: 'meetings#desired', as: :meetings_desired          # 希望日登録モーダル
    patch ':child_id/meetings/desired', to: 'meetings#desired_update', as: :desired_update    # 面談希望日等決定
  end

end
