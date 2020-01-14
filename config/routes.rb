Rails.application.routes.draw do

  root to: 'sessions#new'                                                                                      # 保護者ログインページ
  get  '/login/teacher', to: 'sessions#new2'                                                                   # 教員ログインページ
  get '/signup', to: 'users#new'                                                                               # 保護者新規作成ページ
  get '/signup/:id/child', to: 'users#new2', as: :signup_child                                                 # 生徒新規作成ページ
  post '/users/:id/child', to: 'users#create2', as: :child_create2                                             # 生徒新規登録

  post   '/login', to: 'sessions#create'                                                                       # 保護者ログイン処理
  post   '/login/teacher', to: 'sessions#create2', as: :teacher_login                                          # 教員ログイン処理
  delete '/logout', to: 'sessions#destroy'                                                                     # 保護者ログアウト処理
  delete '/logout/teacher', to: 'sessions#destroy2', as: :teacher_logout                                       # 教員ログアウト処理
  post '/push' => 'linebot#push'                                                                               # Lineプッシュ処理

  resources :teachers do
    get 'index2', to: 'teachers#index2', as: :teacher_index2                                                   # 保護者一覧ページ
    get 'show2/:user_id', to: 'teachers#show2', as: :teacher_show2                                             # 保護者詳細ページ
    get 't_message', to: 'teachers#t_message', as: :t_message                                                  # 個別連絡ページ
    post 't_message_create', to: 'teachers#t_message_create', as: :t_message_create                            # 個別連絡送信
    get ':id/t_message_reply', to: 'teachers#t_message_reply', as: :t_message_reply                            # 保護者への返信ページ
    patch ':id/t_message_reply_send', to: 'teachers#t_message_reply_send', as: :t_message_reply_send           # 保護者への返信処理
    get 'meetings/new', to: 'meetings#new'                                                                     # 面談日時登録ページ
    post 'meetings/create', to: 'meetings#create', as: :meeting_create                                         # 面談日作成
    post 'meetings/create2', to: 'meetings#create2', as: :meeting_create2                                      # 面談時間作成
    get 'meetings/edit', to: 'meetings#edit'                                                                   # 面談日時編集・送信ページ
    patch 'meetings/edit', to: 'meetings#update', as: :meetings_update                                         # 面談日時更新
    delete 'meetings/destroy', to: 'meetings#destroy', as: :meetings_destroy                                   # 面談日時個別削除
    get 'meetings', to: 'meetings#index', as: :meetings_index                                                  # 面談スケジュール調整ページ
    get 'meetings/status', to: 'meetings#index2', as: :meeting_index2                                          # 面談状況確認ページ
    patch 'meetings', to: 'meetings#schedule_update', as: :schedule_update                                     # 面談スケジュール更新
    collection do 
      get 'help'                                                                                               #教員説明ヘルプページ
    end  
  end

  resources :users do
    get  'messages', to: 'users#messages', as: :users_messages                                                 # 先生からのお便り一覧
    get  'p_message', to: 'users#p_message', as: :p_message                                                    # 教員へ連絡ページ
    post 'p_message_create', to: 'users#p_message_create', as: :p_message_create                               # 教員へ連絡送信
    get  'children/index2', to: 'users#index2', as: :users_index2                                              # 生徒情報登録/編集ページ
    get  ':child_id/edit2', to: 'users#edit2', as: :users_edit2                                                # 生徒情報編集ページ
    patch ':child_id/edit2', to: 'users#update2', as: :users_update2                                           # 生徒情報更新
    delete ':child_id/destroy', to: 'users#child_destroy', as: :child_destroy                                  # 生徒情報削除
    get  ':child_id/meetings/new_user', to: 'meetings#new_user', as: :meetings_new_user                        # 保護者面談日時登録ページ
    get  ':child_id/meetings/desired', to: 'meetings#desired', as: :meetings_desired                           # 希望日登録モーダル
    patch ':child_id/meetings/desired', to: 'meetings#desired_update', as: :desired_update                     # 面談希望日等決定
    get   '/documets', to: 'users#document_show'                                                               #保護者提出ページへ
    get   '/documetView/:id', to: 'users#document_view',as:  :document_view                                    #保護者提出一覧へ
    get   "file_show/:document_id",to:"users#file_show",as: :file_show                                         #提出後保護者ﾘﾝｸ
  end
  get  '/document_link/modal/:id', to: 'users#link', as: :document_link                                        #外部サービスモーダル

  resources :documents do
    get '/new',to: 'document_items#new',  as: :question                                                        #選択式提出質問作成ページ
    get '/new2',to: 'document_items#new2',  as: :question2                                                     #入力式提出質問作成ページ
    post '/itemcreate',to: 'document_items#create', as: :item_create                                           #選択式質問登録処理
    post '/itemcreate2',to: 'document_items#create2', as: :item_create2                                        #入力式質問登録処理
    patch '/update/item',to: 'documents#item_update'                                                           #質問項目編集
    patch '/update/select',to: 'documents#select_update'                                                       #選択肢編集
    post  '/item_add',to:'documents#update_add'                                                                #編集画面質問追加
    post  '/select_add',to:'documents#update_select_add'                                                       #編集画面選択追加
    get   'users_view' ,to:'documents#user_view'                                                               #保護者提出回答一覧
    collection do
      get 'pdf_modal'
    end
    member do
      post 'message'
    end  
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
  delete 'documentitem/delete/:id',to:'documents#delete_item',as: :document_destroy                            #編集画面質問削除
  delete 'documentSelect/delete/:id',to:'documents#delete_select',as: :document_select_destroy
  delete "document/file_delete/:document_id",to:"documents#file_delete",as: :file_delete                       #教員ファイル削除
  get "document/public_change/:document_id",to:"documents#public_change",as: :public_change                    #保護者へ提出
  get 'select_document/first',to:'documents#select_modal',as: :select_first_modal                              #選択式最初のページモーダル
  get 'select_document/second',to:'document_items#select_modal',as: :select_second_modal                       #選択式2番目のページモーダル
  get 'select_document/third',to:'document_selects#select_modal',as: :select_third_modal                       #選択式3番目のページモーダル
  get 'input_document/first',to:'documents#input_modal',as: :input_first_modal                                 #入力式最初のページモーダル
  get 'input_document/second',to:'document_items#input_modal',as: :input_second_modal                          #入力式2番目のページモーダル
  get 'document_select/:id/select',to:'documents#document_modal',as: :document_select_editmodal                #選択肢編集モーダル
  post 'document/check_delete',to:'documents#check_delete',as: :document_check_delete                          #教員チェックボックス複数削除
  post "documents/selectform/:id",to:"users#selectform",as: :selectform                                        #保護者選択式フォームpost送信
  post "documents/inputform/:id",to:"users#inputform",as: :inputform                                           #保護者入力式フォームpost送信
  resources :answers do
    get "modal/:num",  to:"documents#answer_modal",as: :modal                                                  #ピックアップモーダル
  end
end
