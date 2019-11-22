class DocumentItemsController < ApplicationController
  #新規選択式作成フォーム
  def new
    @document = Document.find(params[:document_id])
    @document_item = DocumentItem.new
  end
  #選択式質問登録
  def create
     @document = Document.find(params[:document_id])
    
    #未入力処理
    if params[:content].blank?
      flash[:danger] = "必ず入力してください。" 
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
  
end
