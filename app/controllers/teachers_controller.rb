class TeachersController < ApplicationController

  # 教員トップページ
  def show
    @teacher = Teacher.find(params[:id])
    #教員ページにてitem_check/select_check(途中でブラウザ閉じurlによるページ移動)trueでdocument_item/document_selectゼロならdocument削除
    document_delete2
  end

  # 保護者一覧ページ
  def index2
    @teacher = Teacher.find(params[:teacher_id])
    @users = User.all
  end

end
