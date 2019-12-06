class TeachersController < ApplicationController

  # 教員トップページ
  def show
    @teacher = Teacher.find(params[:id])
    @p_messages = @teacher.p_messages.all
    #教員ページにてitem_check/select_check(途中でブラウザ閉じurlによるページ移動)trueでdocument_item/document_selectゼロならdocument削除
    document_delete2
  end

  # 保護者一覧ページ
  def index2
    @teacher = Teacher.find(params[:teacher_id])
    @users = User.all
  end

  # 個別連絡ページ
  def t_message
    @teacher = Teacher.find(params[:teacher_id])
    @children = @teacher.children.all
    @users = User.joins(:children).where(children: {teacher_id: @teacher.id})
    @users_name = @users.uniq.map{|m| m.name + m.name2}
    @t_message = @teacher.t_messages.build
  end

  # 個別連絡送信
  def t_message_create
    @teacher = Teacher.find(params[:teacher_id])
    @t_message = @teacher.t_messages.build(t_message_params)
    if @t_message.save
      flash[:success] = "送信しました。"
      redirect_to teacher_path(@teacher)
    else
      flash[:danger] = "失敗"
      redirect_to teacher_t_message_path(@teacher)
    end
  end

  private

    # 個別連絡
    def t_message_params
      params.require(:t_message).permit(:title, :content, select_user: [])
    end

end
