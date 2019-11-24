class DocumentSelectsController < ApplicationController
  #選択肢作成ページ
  def new
    @document_select = DocumentSelect.new
    @document_item = DocumentItem.find(params[:document_item_id]) 
    @select_count = @document_item.document_selects.all.count 
  end
  #選択肢登録
  def create
    @document_item = DocumentItem.find(params[:document_item_id])
    if params[:content].blank?
      flash[:danger] = "必ず書き込んでください。"
      redirect_to document_item_select_url(@document_item)
    else
      @document_items = DocumentItem.where(content: @document_item.content,randam: @document_item.randam) #前項のdocumentからのid content
      @document_items.each do |item|
      record = item.document_selects.build(content: params[:content],document_item_id: item.id)
      record.save
    end  
    @document_select = DocumentSelect.where(document_item_id: @document_item.id).last
    flash[:danger] = "引き続き項目作るならフォーム入力して送信を終わりなら終了ボタン押してください"
    redirect_to document_item_select_path(@document_select.document_item_id)
    end    
  end

  #選択式作成質問ページモーダル
  def select_modal
  end
  
end
