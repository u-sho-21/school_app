Rails.application.routes.draw do

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :teachers do

    get 'meetings/new', to: 'meetings#new'                                                                     # 面談日時登録ページ
    post 'meetings', to: 'meetings#create'                                                                     # 面談日作成
    post 'meeting_times', to: 'meeting_times#create'                                                           # 面談時間作成
    get 'meetings/edit', to: 'meetings#edit'                                                                   # 面談日時編集・送信ページ
    patch 'meetings/edit', to: 'meetings#update', as: :meetings_update                                         # 面談日時更新
  end

  resources :users do
    get  ':child_id/meetings/new_user', to: 'meetings#new_user', as: :meetings_new_user                        # 保護者面談日時登録ページ
    get  ':child_id/meetings/desired', to: 'meetings#desired', as: :meetings_desired                           # 希望日登録モーダル
    patch ':child_id/meetings/desired', to: 'meetings#desired_update', as: :desired_update                     # 面談希望日等決定
  end

  resources :users
  resources :documents do
    get '/new',to: 'document_items#new',  as: :question                                                        #選択式提出質問作成ページ
    get '/new2',to: 'document_items#new2',  as: :question2                                                     #入力式提出質問作成ページ
    post '/itemcreate',to: 'document_items#create', as: :item_create                                           #選択式質問登録処理
    post '/itemcreate2',to: 'document_items#create2', as: :item_create2                                        #入力式質問登録処理
   
  end
  get 'document/new2',to:"documents#new2",as: :new2_document                                                   #入力式書類作成ページ  
  post 'document/create2',to:'documents#create2',as: :document_create2                                         #入力式書類登録処理
  get 'document/new3',to:"documents#new3",as: :new3_document                                                   #表示式書類作成ページ
  post 'document/create3',to:'documents#create3',as: :document_create3                                         #表示式書類登録処理

  resources :document_items do
    get '/new',to: 'document_selects#new',  as: :select                                                        #選択式提出選択肢作成ページ  
  end
  post 'document_select/:document_item_id',to:'document_selects#create',as: :selectcreate                      #選択肢選択肢登録
  resources :document_selects
  delete "document/file_delete/:document_id",to:"documents#file_delete",as: :file_delete                       #教員ファイル削除
  get "document/public_change/:document_id",to:"documents#public_change",as: :public_change                    #保護者へ提出
  
end
