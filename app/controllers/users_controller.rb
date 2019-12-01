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
    @child = @user.children.build(name_1: params[:name_1], name_2: params[:name_2], teacher_id: 1)
    if @child.save
      flash[:success] = '生徒の登録をしました。もう一人登録する場合はトップページの新規登録からお願いします。'
      @child.update_attributes(full_name: "#{@child.name_1}#{@child.name_2}")
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

  def document_view
    @document = Document.find(params[:id])
    @input_count = @document.document_items.all.count
    @select_count = select_zerocount?
    @user = User.find(params[:user_id]) 
  end
  

  private

    def user_params
      params.require(:user).permit(:name, :name2, :email, :phone, :password, :password_confirmation)
    end

end
