class DocumentSelectsController < ApplicationController
  before_action :set_teacher
  
  #選択肢作成ページ
  def new
    @document_select = DocumentSelect.new
    @document_item = DocumentItem.find(params[:document_item_id])
    select_check_passage               #選択式でdocument#new通過時item_check trueへ  
    @select_count = @document_item.document_selects.all.count 
  end
  #選択肢登録
  def create
    @document_item = DocumentItem.find(params[:document_item_id])
    randam = SecureRandom.alphanumeric(10)
    if params[:content].blank?
      flash[:danger] = "必ず書き込んでください。"
      redirect_to document_item_select_url(@document_item)
    elsif params[:content].length > 50   
      flash[:danger] = "50文字以内でお願いします。"
      redirect_to document_item_select_url(@document_item)
    else
      @document_items = DocumentItem.where(content: @document_item.content,randam: @document_item.randam) #前項のdocumentからのid content
      @document_items.each do |item|
      record = item.document_selects.build(content: params[:content],document_item_id: item.id)
      record.randam = randam 
      record.save
    end 
    @select_count =  DocumentSelect.where(document_item_id: @document_item.id).all.count
    @document_select = DocumentSelect.where(document_item_id: @document_item.id).last
    if @select_count >=2
      flash[:danger] = "引き続き項目作るならフォーム入力して送信を終わりなら終了ボタン押してください"
    elsif @select_count <2
      flash[:danger] = "一つ目を作成しました。引き続き二つ目作成してください。"
    end 
    redirect_to document_item_select_path(@document_select.document_item_id)   
  end
end

  #選択式作成質問ページモーダル
  def select_modal
  end
  
end
