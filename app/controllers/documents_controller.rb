class DocumentsController < ApplicationController
  before_action :set_document, only:[:edit, :updata]
  #掲出状況確認(教員)
  def index
    #教員をユーザーid 1にセットしそれを元に資料を操作していく
    @user = User.find 1 #教員
    @users_count = User.all.count-1 #教員の数のみマイナス
    @documents = @user.documents.all    
  #教員ページにてitem_check/select_check(途中でブラウザ閉じurlによるページ移動)trueでdocument_item/document_selectゼロならdocument削除
    document_delete2
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
        redirect_to new2_document_url(document_params)
        return
      end    
  end
  @document = Document.all.last  #作られたユーザーごとの資料の最後
  redirect_to document_question2_url(@document)
  return
end

#表示式作成ページ  
def new3
  @document = Document.new 
end 

#表示式書類db格納
def create3             
  @user = User.all
  randam = SecureRandom.alphanumeric(10)
  @user.each do |user|
      record = user.documents.build(document_params)
      record.randam = randam
      record.user_id = user.id
      if params[:document][:pdf_link].present?
        if record.save
          if user.id == 1
            record.public = true
            record.save
          end  
        else
          #自作errorチェック
          error_check
          redirect_to new3_document_url(document_params)
          return
        end
      else
        pdf_error_check
        redirect_to new3_document_url(document_params)
        return  
      end    
  end
  @document = Document.all.last  #作られたユーザーごとの資料の最後
  redirect_to teacher_url(1)
  return
end  

#document編集ページ
def edit
end

#document編集
def update
  @document = Document.find(params[:id])
  documents = Document.where(memo: @document.memo, randam: @document.randam)
  documents.each do |document|
    unless document.update_attributes(document_params)
      #自作errorチェック
      error_check
      redirect_to edit_document_url(document_params)
      return
    end    
  end  
  redirect_to teacher_url(1)
  return
end


#教員ファイル削除
def file_delete
  document = Document.find(params[:document_id])
   Document.where(memo: document.memo, randam: document.randam).destroy_all
  flash[:danger] = "資料を削除しました。"
  redirect_to documents_url
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

#選択式作成初期ページモーダル
def select_modal
end

#入力式作成初期ページモーダル
def input_modal
end

#選択肢編集モーダル
def document_modal
  @document_item = DocumentItem.find(params[:id])
end

#質問編集
def item_update
  @document = Document.find(params[:document_id])
  documents = Document.where(memo:@document.memo,randam: @document.randam)
  item_parameter.each do |id,it|
   item = DocumentItem.find id
   item.update_attributes(it)
  end 
  update_items = @document.document_items.all 
  documents = Document.where(memo: @document.memo, randam: @document.randam)
  documents.each do |document|
    update_items.each do |up_item|
       objs = document.document_items.where(randam: up_item.randam)
       objs.each do |obj|
        obj.update_attributes(content: up_item.content)
       end 

    end
  end  
  redirect_to documents_url
end

#選択肢編集
def select_update
  @document_item = DocumentItem.find(params[:document_id])
  sampleselect = @document_item.document_selects.last
  select_parameter.each do |id,item|
    select = DocumentSelect.find id
    select.update_attributes(item)
  end  
  update_selects = @document_item.document_selects.all
  items = DocumentItem.where(content: @document_item.content, randam: @document_item.randam)
  items.each do |item|
    objs = item.document_selects.all
    objs.count.times do |i|
      objs[i].update_attributes(content: update_selects[i].content)
    end  
  end  
  redirect_to documents_url
end

#編集の際質問項目追加
 def update_add
   @document =Document.find(params[:document_id])
   documents = Document.where(memo: @document.memo, randam: @document.randam) #同じ条件のdocument取り出し。
   randam = SecureRandom.alphanumeric(10)
   documents.each do |document|
     record = document.document_items.build(content: params[:content])
     record.randam = randam
     record.document_id = document.id
     record.save
   end 
   redirect_to documents_url
 end
 

#保護者側書類show
def show
  @document = Document.find(params[:id])
  @input_count = @document.document_items.all.count
  @select_count = select_zerocount?
end  
private
  def document_params
    params[:document][:pdf_link] = view_url(params[:document][:service],params[:document][:service_url])
    params.require(:document).permit(:title, :memo, :pdf_link, :deadline)
  end
  
  def set_document
    @document = Document.find(params[:id])
  end
  
  #質問編集パラメーター
  def item_parameter
    params.permit(items:[:content])[:items]
  end

  #選択肢編集パラメーター
  def select_parameter
    params.permit(selects:[:content])[:selects]
  end
  
  
end
