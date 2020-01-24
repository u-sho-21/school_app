class UsersController < ApplicationController
  before_action :login_check, only:[:new]

  # 保護者トップページ
  def show
    @user = User.find(params[:id])
    @child = @user.children.first
    @teacher = Teacher.find(@child.teacher_id)
    @t_message = @teacher.t_messages.last
    session[:child_id] = @child.id unless @child.nil?
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
    if @child.nil?
      @teacher = Teacher.find 1
    else
      @teacher = Teacher.find(@child.teacher_id)
    end
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


  #保護者提出ページ
  def document_show
    @user = User.find(params[:user_id])
    @documents = @user.documents.all.where('deadline >= ?',Date.today).order("id asc")
    public_check
    @user.documents.each do |document|
      if document.deadline < Date.today
        document.public = false
        document.save
      end
    end
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
  @user = User.find @document.user.id
  answer = Answer.new
  answer.document_id = params[:id]
  reply = ""
  @document.document_items.count.times do |i|
    str = "rd"+(i+1).to_s
    if params[str].present?
      reply += params[str] + ":\t"
    elsif params[str].blank?
      reply += ":\t"
    end
  end
  objs = reply.split(":\t")
  objs.each do |obj|
    if obj.blank?
      flash[:danger] = "必須です。必ず各項目選択ください。"
      redirect_to user_document_view_path(@user,@document,params:{reply: reply})
      return
    end
  end
  answer.reply = reply
  answer.user_id = current_user.id
  if answer.save
   redirect_to user_url(current_user)
  else
    render :selectform
  end
end

#入力式保護者処理
def inputform
  @document = Document.find(params[:id])
  @user = User.find @document.user.id
  answer = Answer.new
  answer.document_id = params[:id]
  reply = ""
  @document.document_items.count.times do |i|
    str= "tx"+i.to_s
    if params[str].present?
      reply += params[str]+":\t"
    else
      reply += "null:"
    end
  end
    objs = reply.split(":\t")
    reply =""
    objs.length.times do |i|
      if objs[i] == "null"
        objs[i] = ""
      end
      reply += objs[i].to_s+":\t"
    end
    objs.each do |ob|
      if ob.blank?
        flash[:danger] = "必須です。入力してください。"
        redirect_to user_document_view_path(@user,@document,params:{reply: reply})
        return
      end
    end
  answer.reply = reply
  answer.user_id = current_user.id
  if answer.save
    redirect_to user_url(current_user)
  else
    render :inputform
  end
end

#保護者提出済みファイル表示ページ
def file_show
  @document = Document.find(params[:document_id])
  @user = User.find(params[:user_id])
  @items = @document.document_items.all
  @count = @items.count
  @answers = @document.answers.last.reply.split(":\t")

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

  # 生徒情報削除
  def child_destroy
    @user = User.find(params[:user_id])
    @child = @user.children.find(params[:child_id])
    @child.destroy
    flash[:success] = "生徒情報を削除しました。"
    redirect_to user_users_index2_url(@user)
  end

  # 先生からのお便り一覧
  def messages
    @user = User.find(params[:user_id])
    @child = @user.children.first
    @teacher = Teacher.find(@child.teacher_id)
    @t_message = @teacher.t_messages.last
    @t_messages = @teacher.t_messages.all
    @p_messages = @user.p_messages.all
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
      flash.now[:danger] = "入力に誤りがあります。"
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
