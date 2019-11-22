class DocumentsController < ApplicationController
  def index
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
        @errors = ""
        @errors += "タイトルが有りません。:" unless params[:document][:title].present?
        @errors += "概要は必須です。:" unless params[:document][:memo].present?
        @errors += "期限は必須です。:" unless params[:document][:deadline].present?
          
        flash[:danger] = @errors
        redirect_to new_document_url(document_params)
        return
      end    
    end
    @document = Document.all.last  #作られたユーザーごとの資料の最後
    redirect_to "/documents_items/new/"+@document.id.to_s
    return
  end
private
  def document_params
    params[:document][:pdf_link] = view_url(params[:document][:service],params[:document][:service_url])
    params.require(:document).permit(:title, :memo, :pdf_link, :deadline)
  end  
end
