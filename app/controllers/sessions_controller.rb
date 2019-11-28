class SessionsController < ApplicationController

  # 保護者ログインページ(rootページでもある)
  def new
  end

  # 教員ログインページ
  def new2
  end

  # 保護者ログイン処理
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new
    end
  end

  # 教員ログイン処理
  def create2
    teacher = Teacher.find_by(email: params[:session][:email].downcase)
    if teacher && teacher.authenticate(params[:session][:password])
      log_in_teacher teacher
      params[:session][:remember_me] == '2' ? remember_teacher(teacher) : forget_teacher(teacher)
      redirect_to teacher
    else
      flash.now[:danger] = '認証に失敗しました。'
      render :new2
    end
  end

  # 保護者ログアウト処理
  def destroy
    log_out if logged_in?
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end

  # 教員ログアウト処理
  def destroy2
    log_out_teacher if logged_in_teacher?
    flash[:success] = 'ログアウトしました。'
    redirect_to root_url
  end

end
