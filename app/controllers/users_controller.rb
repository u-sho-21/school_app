class UsersController < ApplicationController

  # 保護者トップページ
  def show
    @user = User.find(params[:id])
    @child = @user.children.first
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
    @child = @user.children.first
    @teacher = Teacher.find(@child.teacher_id)
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
    @child = @user.children.build(child_params)
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
      render :new2
    end
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
      render :edit
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
    else
      render :edit2
    end
  end

  # 先生からのお便り一覧
  def messages
    @user = User.find(params[:user_id])
    @child = @user.children.first
    @teacher = Teacher.find(@child.teacher_id)
    @t_messages = @teacher.t_messages.all
  end

  # 先生への連絡ページ
  def p_message
    @user = User.find(params[:user_id])
    @child = @user.children.first
    @teacher = Teacher.find(@child.teacher_id)
    @p_message = @user.p_messages.build
  end

  # 先生への連絡送信
  def p_message_create
    @user = User.find(params[:user_id])
    @child = @user.children.first
    @teacher = Teacher.find(@child.teacher_id)
    @p_message = @user.p_messages.build(p_message_params)
    if @p_message.save
      flash[:success] = "送信しました。"
      redirect_to user_url(@user)
    else
      flash.now[:danger] = "失敗です。"
      render :p_message
    end
  end

  private
    # 保護者情報登録/更新
    def user_params
      params.require(:user).permit(:name, :name2, :email, :phone, :password, :password_confirmation)
    end

    # 生徒情報登録/更新
    def child_params
      params.require(:child).permit(:name_1, :name_2, :teacher_id)
    end

    # 先生への連絡
    def p_message_params
      params.require(:p_message).permit(:title, :content, :teacher_id)
    end

end
