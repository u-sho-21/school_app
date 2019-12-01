module DocumentItemsHelper
  #教員提出保護者から何件提出されたか？
  def reply_count(memo,randam)
    documents = Document.where(memo: memo, randam: randam) #条件の提出抽出
    count = 0                                              #保護者の提出数

    documents.each do |document|
      if document.answers.all.count > 0
        count += 1
      end    
    end    
    return count
  end 

#保護者の場合、レコードが一の場合でpublic falseの場合th非表示
  def public_check
    result = false
    if !@user.id == 1 && @user.documents.all.count == 1
      document = @user.documents.all.last
      if document.public == false
        result = false
      end

    #複数レコードがある場合public trueが一つでもあればtrue  
    elsif @user.documents.all.count > 1 
      count = 0
      documents = @user.documents.all
      documents.each do |document|
        if document.public == true
          count += 1
        end  
        if count > 0
          result = true
        end  
      end 
    end  
    return result
  end

  #errorチェック
  def error_check
    @errors = ""
    @errors += "タイトルが有りません。:" unless params[:document][:title].present?
    @errors += "概要は必須です。:" unless params[:document][:memo].present?
    @errors += "期限は必須です。:" unless params[:document][:deadline].present?
    @errors += "日付けが過ぎてます。:"  unless document_date_check?(params[:document][:deadline])  
    flash[:danger] = @errors
  end

  #表示式用errorチェック
  def pdf_error_check
    @errors = ""
    @errors += "タイトルが有りません。:" unless params[:document][:title].present?
    @errors += "概要は必須です。:" unless params[:document][:memo].present?
    @errors += "期限は必須です。:" unless params[:document][:deadline].present?
    @errors += "この書類では入力ください。:" unless params[:document][:pdf_link].present?
    @errors += "日付けが過ぎてます。:"  unless document_date_check?(params[:document][:deadline])  
    flash[:danger] = @errors
  end


  #選択式/入力式は通過時trueにする。
  def item_check_passage
    documents = Document.where(memo: @document.memo,randam: @document.randam)
    documents.each do |document|
      document.update_attributes(item_check: true)
    end  
  end

  def set_teacher
    if session[:teacher_id].nil?
      if logged_in?
        redirect_to user_url(current_user)
      else
        redirect_to root_url  
      end  
    else  
      @teacher = Teacher.find(session[:teacher_id])
    end  
  end  
    

end
