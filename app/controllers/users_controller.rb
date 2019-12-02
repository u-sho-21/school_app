class UsersController < ApplicationController

  # 保護者トップページ
  def show
    @user = User.find(params[:id])
    @child = Child.where(user_id: @user.id).first
    if @child.nil?
      redirect_to signup_child_url
    end
  end

  # 保護者新規作成ページ
  def new
    @user = User.new
  end

  # 生徒新規登録ページ
  def new2
    @user = User.find(params[:id])
    @child = @user.children.build
  end

  # 保護者新規登録
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'アカウントを作成しました。次に生徒登録をしてください。'
      redirect_to @user
    else
      render :new
    end
  end

  # 生徒新規登録
  def create2
    @user = User.find(params[:id])
    @child = @user.children.build(name_1: params[:name_1], name_2: params[:name_2], teacher_id: 1) # 先生が一人の場合のみ限定
    @teacher = Teacher.find(@child.teacher_id)
    @meetings = @teacher.meetings.all
    if @child.save
      flash[:success] = '生徒の登録をしました。もう一人登録する場合はトップページの「生徒さん登録/編集」からお願いします。'
      @child.update_attributes(full_name: "#{@child.name_1}#{@child.name_2}")
      # 面談日レコードが0でない場合、レコードを作る
      dates.each do |day|
        unless @teacher.meetings.any? {|meeting| meeting == @teacher.meetings.find_by(date: day, child_id: @child.id)}
          @teacher.children.where(teacher_id: @teacher.id, user_id: @user.id).each do |child|   # 保護者紐付けの生徒が二人いた場合
            record = @teacher.meetings.build(date: day, child_id: @child.id)
            record.save
          end
        end
      end
      redirect_to @user
    else
      flash.now[:danger] = "入力内容が間違っています。"
      render :new2
    end
  end


  #保護者提出ページ
  def document_show
    @user = User.find(params[:user_id])
    @documents = @user.documents.all
    public_check
    
  end

  #保護者提出一覧ページ
  def document_view
    @document = Document.find(params[:id])
    @input_count = @document.document_items.all.count
    @select_count = select_zerocount?
    @user = User.find(params[:user_id]) 
  end

  #保護者提出外部サービスﾘﾝｸ
  def link
    @document = Document.find(params[:id])
  end
  
  #選択式保護者処理
def selectform
  @document = Document.find(params[:id])
  answer = Answer.new
  answer.document_id = params[:id]
  reply = ""
  100.times do |i|
    str = "rd"+i.to_s
    if params[str].present?
      reply += params[str] + ":"
    end  
  end  
  answer.reply = reply
  answer.user_id = current_user.id
  if answer.save
    debugger
   redirect_to user_url(current_user)
  else 
    render :selectform
  end 
end

#ユーザー用ファイル表示  
def file_show
  @document = Document.find(params[:document_id])
end
  
  # 保護者削除
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "#{@user.name + @user.name2}さんの登録情報を削除しました。"
    redirect_to teacher_teacher_index2_url(params[:teacher_id])
  end

  # 保護者編集ページ
  def edit
    @user = User.find(params[:id])
  end

  # 保護者更新
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.name + @user.name2}さんの登録情報を更新しました。"
      redirect_to user_url(@user)
    else
      flash[:danger] = "失敗"
      redirect_to user_url(@user)
    end
  end


  # 生徒情報登録/編集ページ
  def index2
    @user = User.find(params[:user_id])
    @children = @user.children.all
  end

  # 生徒情報編集ページ
  def edit2
    @user = User.find(params[:user_id])
    @child = @user.children.find(params[:child_id])
  end

  # 生徒情報更新
  def update2
    @user = User.find(params[:user_id])
    @child = @user.children.find(params[:child_id])
    if @child.update_attributes(child_params)
      @child.update_attributes(full_name: @child.name_1 + @child.name_2)
      flash[:success] = "生徒さん情報を更新しました。"
      redirect_to user_users_index2_url(@user)
    end
  end

  private
    # 保護者情報登録/更新
    def user_params
      params.require(:user).permit(:name, :name2, :email, :phone, :password, :password_confirmation)
    end

    # 生徒情報登録/更新
    def child_params
      params.require(:child).permit(:name_1, :name_2)
    end

end
