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
    teacher.remember
    cookies.permanent.signed[:user_id] = teacher.id
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
    teacher.forget
    cookies.delete(:teacher_id)
    cookies.delete(:teacher_token)
  end

  # 保護者ログアウト
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 教員ログアウト
  def log_out_teacher
    forget(current_teacher)
    session.delete(:teacher_id)
    @current_user = nil
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
      if teacher && teacher.authenticated?(cookies[:remember_token])
        log_in teacher
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
end
