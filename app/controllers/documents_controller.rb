class DocumentsController < ApplicationController
  before_action: set_userdocument,only:[:create, :create2]

  #掲出状況確認(教員)
  def index
    #教員をユーザーid 1にセットしそれを元に資料を操作していく
    @user = User.find 1 #教員
    @users_count = User.all.count-1 #教員の数のみマイナス
    @documents = @user.documents.all    
  end
#選択式新規作成ページ
  def new
    @document = Document.new
  end
#選択式書類db格納
  def create
  @user = User.all
  randam = SecureRandom.alphanumeric(10)
  @user.each do |user|
      record = user.documents.build(document_params)
      record.randam = randam
      record.user_id = user.id
      if record.save
        if user.id == 1
          record.public = true
          record.save
        end  
      else
        #自作errorチェック
        error_check
        redirect_to new_document_url(document_params)
        return
      end    
  end
  @document = Document.all.last  #作られたユーザーごとの資料の最後
    redirect_to document_question_url(@document)
    return
  end

#入力式作成ページ  
def new2
  @document = Document.new 
end    

#入力式書類db格納
def create2             
    provide(:route,"2")
    redirect_to document_question_url(@document)
    return
  end

#教員ファイル削除
def file_delete
  document = Document.find(params[:document_id])
  documents = Document.where(memo: document.memo, randam: document.randam)
  documents.delete_all
  flash[:danger] = "資料を削除しました。"
  redirect_to teacher2_url
end
 #保護者へ作成した書類公表
 def public_change
   document = Document.find(params[:document_id])
   @documents = Document.where(memo: document.memo, randam: document.randam)
   @documents.each do |document|
     document.public =true
     document.save
  end  
  flash[:sucess] = "保護者に提出しました。"
  redirect_to teacher2_url
end
  
private
  def document_params
    params[:document][:pdf_link] = view_url(params[:document][:service],params[:document][:service_url])
    params.require(:document).permit(:title, :memo, :pdf_link, :deadline)
  end
  
  def set_userdocument
    @user = User.all
  randam = SecureRandom.alphanumeric(10)
  @user.each do |user|
      record = user.documents.build(document_params)
      record.randam = randam
      record.user_id = user.id
      if record.save
        if user.id == 1
          record.public = true
          record.save
        end  
      else
        #自作errorチェック
        error_check
        redirect_to new"#{yield(:route)}"_document_url(document_params)
        return
      end    
  end
  @document = Document.all.last  #作られたユーザーごとの資料の最後
  end
  
end
