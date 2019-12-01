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

  # 保護者削除
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:danger] = "#{@user.name + @user.name2}さんの登録情報を削除しました。"
    redirect_to teacher_teacher_index2_url(params[:teacher_id])
  end

  private

    def user_params
      params.require(:user).permit(:name, :name2, :email, :phone, :password, :password_confirmation)
    end

end
