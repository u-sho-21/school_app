module SessionsHelper

  # 保護者ログインセッション
  def log_in(user)
    session[:user_id] = user.id
  end

  # 教員ログインセッション
  def log_in_teacher(teacher)
    session[:teacher_id] = teacher.id
  end

  # 保護者remember
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # 教員remember
  def remember_teacher(teacher)
    teacher.remember_teacher
    cookies.permanent.signed[:teacher_id] = teacher.id
    cookies.permanent[:remember_token] = teacher.remember_token
  end

  # 保護者forget
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 教員forget
  def forget_teacher(teacher)
    teacher.forget_teacher
    cookies.delete(:teacher_id)
    cookies.delete(:remember_token)
  end

  # 保護者ログアウト
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 教員ログアウト
  def log_out_teacher
    forget_teacher(current_teacher)
    session.delete(:teacher_id)
    @current_teacher = nil
  end

  # 保護者現在ユーザー
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 教員現在ユーザー
  def current_teacher
    if (teacher_id = session[:teacher_id])
      @current_teacher ||= Teacher.find_by(id: teacher_id)
    elsif (teacher_id = cookies.signed[:teacher_id])
      teacher = Teacher.find_by(id: teacher_id)
      if teacher && teacher.authenticated_teacher?(cookies[:remember_token])
        log_in_teacher teacher
        @current_teacher = teacher
      end
    end
  end

  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end

  # 渡された教員がログイン済みで教員であればtrueを返す
  def current_teacher?(teacher)
    teacher == current_teacher
  end

  # 保護者ログイン
  def logged_in?
    !current_user.nil?
  end

  # 教員ログイン
  def logged_in_teacher?
    !current_teacher.nil?
  end

  #ヘッダーﾘﾝｸ分岐
  def link_check
    if logged_in?
      return user_path(current_user)
    elsif  logged_in_teacher?
      return teacher_path(current_teacher)
    else  
      return root_path
    end     
  end

  #ログイン時ログイン画面、新規作成画面アクセス不可
   def login_check
     if logged_in?
       redirect_to user_url(current_user)  #保護者ログイン時はログイン画面アクセスでuser showにリダイレクト
     elsif logged_in_teacher?
       redirect_to teacher_url(current_teacher) #教員ログイン時はログイン画面アクセスでteacher showにリダイレクト
     end  
   end
   
  
end
