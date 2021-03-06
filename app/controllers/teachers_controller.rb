class TeachersController < ApplicationController

  # 教員トップページ
  def show
    @teacher = Teacher.find(params[:id])
    @t_messages = @teacher.t_messages.all.order(created_at: "desc")
    #教員ページにてitem_check/select_check(途中でブラウザ閉じurlによるページ移動)trueでdocument_item/document_selectゼロならdocument削除
    document_delete2
  end

  # 保護者一覧ページ
  def index2
    @teacher = Teacher.find(params[:teacher_id])
    @users = User.all
  end

  # 保護者詳細ページ
  def show2
    @teacher = Teacher.find(params[:teacher_id])
    @user = User.find(params[:user_id])
  end

  # お便り送信ページ
  def t_message
    @teacher = Teacher.find(params[:teacher_id])
    @children = @teacher.children.all
    @users = User.joins(:children).where(children: {teacher_id: @teacher.id})
    @users_name = @users.uniq.map{|m| m.name + m.name2}
    @t_message = @teacher.t_messages.build
  end

  # お便り送信
  def t_message_create
    @teacher = Teacher.find(params[:teacher_id])
    @t_message = @teacher.t_messages.build(t_message_params)
    if @t_message.save
      flash[:success] = "送信しました。"
      redirect_to teacher_path(@teacher)
    else
      flash.now[:danger] = "入力に誤りがあります。"
      render :t_message
    end
  end

  # お便り確認
  def t_message_modal
    @teacher = Teacher.find(params[:teacher_id])
    @t_message = @teacher.t_messages.find(params[:id])
  end

  # お便り更新
  def t_message_update
    @teacher = Teacher.find(params[:teacher_id])
    @t_message = @teacher.t_messages.find(params[:id])
    if params[:commit] == "更新"
      @t_message.update_attributes(t_message_params)
      flash[:success] = "更新しました。"
      redirect_to teacher_path(@teacher)
    end
    if params[:commit] == "削除"
      @t_message.delete
      flash[:danger] = "削除しました。"
      redirect_to teacher_path(@teacher)
    end
  end


  # 保護者への返信ページ
  # def t_message_reply
  #   @teacher = Teacher.find(params[:teacher_id])
  #   @p_message = @teacher.p_messages.find(params[:id])
  #   @user = User.find(@p_message.user_id)
  # end

  # 保護者への返信処理
  # def t_message_reply_send
  #   @teacher = Teacher.find(params[:teacher_id])
  #   @p_message = @teacher.p_messages.find(params[:id])
  #   if @p_message.update_attributes(reply: params[:p_message][:reply])
  #     flash[:success] = "返信しました。"
  #     redirect_to teacher_path(@teacher)
  #   else
  #     flash.now[:danger] = "入力に誤りがあります。"
  #     render :t_message_reply
  #   end
  # end

  private

    # 個別連絡
    def t_message_params
      params.require(:t_message).permit(:title, :content)
    end

end
