class DocumentItemsController < ApplicationController
  before_action :set_teacher
  
  #新規選択式作成フォーム
  def new
    @document = Document.find(params[:document_id])
    item_check_passage   #選択式/入力式は通過時trueにする。
    @document_item = DocumentItem.new
  end
  #選択式質問登録
  def create
     @document = Document.find(params[:document_id])
    
    #未入力処理
    if params[:content].blank?
      flash[:danger] = "必ず入力してください。" 
      redirect_to document_question_url(@document)
    elsif params[:content].length > 50   
      flash[:danger] = "50文字以内でお願いします。"
      redirect_to document_question_url(@document)  
    else
      @documents = Document.where(memo: @document.memo,randam: @document.randam)  #メモの内容 ランダム文字列で判別
      randam = SecureRandom.alphanumeric(10)
      @documents.each do |document|
        record = document.document_items.build(content: params[:content])
        record.randam = randam
        record.document_id = document.id
        record.save
         
      end
    @document_item = DocumentItem.all.last
    redirect_to document_item_select_url(@document_item)
    end     
    
  end

   #新規入力式作成フォーム
   def new2
     @document = Document.find(params[:document_id])
     item_check_passage      #選択式/入力式は通過時trueにする。
     @document_item = DocumentItem.new
     @item_count = @document.document_items.all.count
  end

  #入力式質問登録
  def create2
    @document = Document.find(params[:document_id])
   
   #未入力処理
   if params[:content].blank? 
     flash[:danger] = "必ず入力してください。" 
     redirect_to document_question2_url(@document)
   elsif params[:content].length > 50   
    flash[:danger] = "50文字以内でお願いします。"
     redirect_to document_question2_url(@document)
   else
     @documents = Document.where(memo: @document.memo,randam: @document.randam)  #メモの内容 ランダム文字列で判別
     randam = SecureRandom.alphanumeric(10)
     @documents.each do |document|
       record = document.document_items.build(content: params[:content])
       record.randam = randam
       record.document_id = document.id
       record.save
        
     end
   @document_item = DocumentItem.all.last
   flash[:danger] = "引き続き項目作るならフォーム入力して送信を終わりなら終了ボタン押してください"
   redirect_to document_question2_url(@document_item.document_id)
   end

   #選択式作成質問ページモーダル
   def select_modal
   end

   #入力式作成初期ページモーダル
   def input_modal
   end
 end
  
end
