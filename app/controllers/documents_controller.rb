class DocumentsController < ApplicationController
  before_action :set_document, only:[:edit, :updata, :user_view]
  before_action :set_teacher

  #掲出状況確認(教員)
  def index
    if params[:input]
      flash.now[:success] = "作成しました。"
    end 

    #Lineから送られたデーターもとに提出済み処理
    if params[:line_send]
      document = Document.find(params[:line_send])
      @documents = Document.where(memo: document.memo, randam: document.randam)
      @documents.each do |document|
        document.public =true
        document.save
      end  
    end  


    #教員をユーザーid 1にセットしそれを元に資料を操作していく
    @user = User.find 1 #教員
    @users_count = User.all.count-1 #教員の数のみマイナス
    @documents = @user.documents.all.order('id asc')   
  #教員ページにてitem_check/select_check(途中でブラウザ閉じurlによるページ移動)trueでdocument_item/document_selectゼロならdocument削除
    document_delete2

    #公開してない資料数
    @not_public = Document.where(public: false).where('deadline>=?',Date.today).count
    if @not_public > 0
      flash[:success] = "保護者に未提出の書類があります。ご確認ください。"
    end
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
        record.teacher_id = current_teacher.id
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
      record.teacher_id = current_teacher.id
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
      record.teacher_id = current_teacher.id
      if params[:document][:pdf_link].present?
        if record.save
          if user.id == 1
            record.public = true
            record.save
          end  
        else
          #自作errorチェック
          pdf_error_check
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
  flash[:success] = "作成しました。"
  redirect_to documents_url
  return
end  

#document編集ページ
def edit
end

#document編集
def update
  params[:document][:pdf_link] = view_url(params[:document][:service],params[:document][:service_url])
  @document = Document.find(params[:id])
  documents = Document.where(memo: @document.memo, randam: @document.randam)
  documents.each do |document|
    if document.document_items.count == 0;
    #表示式
      if params[:document][:pdf_link].present?
        unless document.update_attributes(document_params) 
          pdf_error_check
          redirect_to edit_document_url(document_params)
          return
        end
      else   
        pdf_error_check
        redirect_to edit_document_url(document_params)
        return   
      end
    #選択、入力
    else
      unless document.update_attributes(document_params) 
        error_check
        redirect_to edit_document_url(document_params)
        return
      end  
    end
  end 
  flash[:success] = "編集しました。" 
  redirect_to documents_url
  return
end


#教員ファイル削除
def file_delete
  document = Document.find(params[:document_id])
   objs =Document.where(memo: document.memo, randam: document.randam)
   objs.each do |obj|
     obj.destroy
   end  
  flash[:danger] = "資料を削除しました。"
  redirect_to documents_url
end
#確認画面
def confirm
  @array = []
  delete_parameter.each do |id,item|
    if item[:check] == "1"
      document = Document.find id
      @array << document
    end 
  end  
end
 


#複数document削除
def check_delete
  delete_parameter.each do |id,item|
    if item[:check] == "1"
      document = Document.find id
      documents = Document.where(memo: document.memo, randam: document.randam)
      documents.each do |obj|
        obj.destroy
      end  
    end  
  end 
  flash[:danger] = "削除しました。" 
  redirect_to documents_url
end


 #保護者へ作成した書類公表
 def public_change
   document = Document.find(params[:document_id])
   redirect_to documents_url(params:{send: document.id}),data: {"turbolinks" => false}
end

def  message
  redirect_to documents_path
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

def pdf_modal
end


#保護者回答一覧モーダル
def answer_modal
  @answer = Answer.find(params[:answer_id])
  @no = params[:num]
end

#質問編集
def item_update
  @document = Document.find(params[:document_id])
  documents = Document.where(memo:@document.memo,randam: @document.randam)
  item_parameter.each do |id,it|
   item = DocumentItem.find id
   unless item.update_attributes(it)
    if it[:content].blank?
      flash[:info] = "質問の編集は空白にしないでください。"
    elsif it[:content].size > 100 
      flash[:info] = "100文字以内でお願いします。"
    end  
    redirect_to edit_document_url(@document)
    return
   end 
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
  flash[:success] = "編集しました。" 
  redirect_to documents_url
end

#選択肢編集
def select_update
  @document_item = DocumentItem.find(params[:document_id])
  sampleselect = @document_item.document_selects.last
  select_parameter.each do |id,item|
    select = DocumentSelect.find id
    unless select.update_attributes(item)
      if item[:content].blank?
        flash[:info] = "選択肢の編集は空白にしないでください。"
      elsif item[:content].size > 100 
        flash[:info] = "100文字以内でお願いします。"
      end  
      redirect_to edit_document_url(@document_item.document) 
      return  
    end  
  end  
  update_selects = @document_item.document_selects.all
  items = DocumentItem.where(content: @document_item.content, randam: @document_item.randam)
  items.each do |item|
    objs = item.document_selects.all
    objs.count.times do |i|
      objs[i].update_attributes(content: update_selects[i].content)
    end  
  end  
  flash[:success] = "編集しました。" 
  redirect_to documents_url
end

#編集の際質問項目追加
 def update_add
   @document =Document.find(params[:document_id])
   documents = Document.where(memo: @document.memo, randam: @document.randam) #同じ条件のdocument取り出し。
   linK_item = nil
   randam = SecureRandom.alphanumeric(10)
   documents.each do |document|
     record = document.document_items.build(content: params[:content])
     record.randam = randam
     record.document_id = document.id
     unless record.save
      if params[:content].blank?
        flash[:info] = "質問の追加の際に空白にしないでください。"
      elsif params[:content].size > 100
        flash[:info] = "100文字以内でお願いします。"
      end    
      redirect_to edit_document_url(@document) 
      return
     end 
     linK_item = record
   end 
   if select_exist == true
    flash[:success] = "追加しました。" 
    redirect_to document_item_select_url(linK_item)
   else select_exist == false
    flash[:success] = "作成しました。"
    redirect_to documents_url
   end 
 end

 #編集の際選択肢目追加
 def update_select_add
  @document_item = DocumentItem.find(params[:document_id])
  items = DocumentItem.where(content: @document_item.content, randam: @document_item.randam)
  items.each do |item|
    record = item.document_selects.build(content: params[:content])
    unless record.save
      if params[:content].blank?
        flash[:info] = "選択肢の追加の際に空白にしないでください。"
      elsif params[:content].size > 100
        flash[:info] = "100文字以内でお願いします。"
      end    
      redirect_to edit_document_url(@document_item.document)
      return
    end  
  end  
  flash[:success] ="選択肢を追加しました"
  redirect_to documents_url
 end

 #編集画面質問削除
 def delete_item
  document = Document.find(params[:obj])
  obj = DocumentItem.find(params[:id])
  documents = DocumentItem.where(content: obj.content, randam: obj.randam )
  documents.each do |document|
    document.destroy
  end  
  flash[:info] = "削除しました。"
  redirect_to edit_document_url(document)
 end

 #編集画面選択肢削除
  def delete_select
    select =  DocumentSelect.find(params[:id])
    DocumentSelect.find(params[:id]).destroy
    selects = DocumentSelect.where(content: select.content, randam: select.randam)
    selects.each do |select|
      select.destroy
    end  
    flash[:danger] = "削除しました。"
    redirect_to documents_path
  end

#保護者側書類show
def show
  @document = Document.find(params[:id])
  @input_count = @document.document_items.all.count
  @select_count = select_zerocount?
  @user = User.find(params[:user]) if params[:user].present?
  respond_to do |format|
    format.html do
    end  

    format.pdf do
      test_pdf = TestPdf.new(@document.id)
      send_data test_pdf.render,
        filename:    "#{@document.title}.pdf",
        type:        'application/pdf',
        disposition: 'inline' 
    end
  end
end  

#保護者の提出した書類教員確認ページ
 def user_view
   @document = Document.find(params[:document_id])
   @users = User.paginate(page: params[:page],per_page: 10).order('id asc')
 end

 #集計ページ
 def aggre
   user = User.find 1
   @documents = user.documents.all
   @userCount = User.all.count-1
   @check = select_agree_check
 end  

 






#*******************************************PRIVATE***************************************************************************
private
  def document_params
    params[:document][:pdf_link] = view_url(params[:document][:service],params[:document][:service_url])
    params.require(:document).permit(:title, :memo, :pdf_link, :deadline, :service_url)
  end
  
  def set_document
    if params[:id]
      @document = Document.find(params[:id])
    elsif params[:document_id]  
      @document = Document.find(params[:document_id])
    end  
  end
#
 
  
  #質問編集パラメーター
  def item_parameter
    params.permit(items:[:content])[:items]
  end

  #選択肢編集パラメーター
  def select_parameter
    params.permit(selects:[:content])[:selects]
  end

  #document複数削除パラメーター
  def delete_parameter
    params.permit(boxs: [:check, :id])[:boxs]
  end
  
end
