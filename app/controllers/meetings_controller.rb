class MeetingsController < ApplicationController
  before_action :correct_teacher,   only: [:new, :create, :edit, :create2, :update, :destroy, :index, :schedule_update, :index2]
  before_action :correct_user,      only: [:new_user, :desired, :desired_update]

  # 面談日時登録ページ
  def new
    @meeting = @teacher.meetings.build
    @meetings = @teacher.meetings.all
    time_list
  end

  # 面談日レコード作成
  def create
    if params[:commit] == "登録"
      unless params[:date].blank?
        @teacher.meeting_delete_all
        params[:date].split("\r\n").each do |day|
          unless @teacher.meetings.any? {|meeting| meeting.date == day}
            @teacher.children.all.each do |child|
              record = @teacher.meetings.build(date: day, child_id: child.id)
              record.save
            end
          end
        end
        flash[:success] = "面談日を登録しました。次に面談時間を登録してください。"
        redirect_to teacher_meetings_new_url
      else
        flash[:danger] = "入力がありません。"
        redirect_to teacher_meetings_new_url
      end
    end

    if params[:commit] == "追加"
      @times = times
      unless @teacher.meetings.any? {|meeting| meeting.date.to_date == params[:date].to_date}
        @teacher.children.all.each do |child|
          record = @teacher.meetings.build(date: params[:date], child_id: child.id)
          record.save
        end
      end

      unless params[:date].blank?
        @times.each do |time|
          addtime = params[:date] + " #{time}"  # 右側の""内の半角スペースは必要なため消さない
          recode = @teacher.meeting_times.build(time: Time.zone.parse(addtime))
          recode.save
        end
        flash[:success] = "面談日時を追加しました。"
        redirect_to teacher_meetings_edit_url(@teacher)
      else
        flash[:danger] = "日付が未入力です。"
        redirect_to teacher_meetings_edit_url(@teacher)
      end
    end

    if params[:commit] == "初期化"
      @teacher.meeting_delete_all
      flash[:danger] = "面談日程を初期化しました。"
      redirect_to teacher_meetings_new_url
    end
  end

  # 面談日時編集・送信ページ
  def edit
    time_list
    @meetings = @teacher.meetings.all
    @meeting_times = @teacher.meeting_times.all.order(:time)
    @meeting_times_status = @teacher.meeting_times.first.status if @meeting_times.present?
    @times = @teacher.meeting_times.map { |time| time.time }
    # 面談日登録がない場合表示されない
    unless @teacher.meeting_times.first.present?
      flash[:info] = "面談日時が登録されていません。"
      redirect_to teacher_url(@teacher)
    end
  end

  # 面談時間レコード作成
  def create2
    @meetings = @teacher.meetings.all
    if params[:commit] == "登録"
      @teacher.meeting_times.all.delete_all
      @times = times

      dates.each do |date|
        @times.each do |time|
          addtime = date.to_s + " #{time}"  # 右側の""内の半角スペースは必要なため消さない
          recode = @teacher.meeting_times.build(time: Time.zone.parse(addtime))
          recode.save
        end
      end
      flash[:success] = "面談時間を登録しました。追加や修正があればこのページで編集してください。"
      redirect_to teacher_meetings_edit_url(@teacher)
    end
  end

  # 面談日時レコード更新
  def update
    if params[:commit] == "更新"
      meeting_times_params.each do |key, value|
        meeting_time = MeetingTime.find(key)
        meeting_time.update_attributes(time: Time.zone.local(value["time(1i)"].to_i,
         value["time(2i)"].to_i, value["time(3i)"].to_i, value["time(4i)"].to_i, value["time(5i)"].to_i))
      end
      flash[:success] = "面談時間を更新しました。"
      redirect_to teacher_meetings_edit_url(@teacher)
    end
  end

  # 面談日時個別削除
  def destroy
    if params[:id]
      @meeting_time = @teacher.meeting_times.find(params[:id])
      @meeting_time.destroy
    elsif params[:date]
      @meetings = @teacher.meetings.where(date: params[:date])
      @meetings.destroy_all
      @meeting_times = @teacher.meeting_times.all
      @meeting_times.each {|meeting_time| meeting_time.destroy if meeting_time.time.to_s(:date) == params[:date]}
    end
    flash[:success] = "削除しました。"
    redirect_to teacher_meetings_edit_url(@teacher)
  end

  # 保護者面談日時登録ページ
  def new_user
    @times_count = @teacher.meeting_times.map{|m| m.time.to_s(:time)}.uniq
    @meeting_times_status = @teacher.meeting_times.first.status if @meeting_times.present?
    @limit_date = @meetings.first.date - 5
    if @meeting_times_status == "meeting_confirm"
      @meeting_confirm = @teacher.meeting_times.find_by(name: @child.full_name)
    end
  end

  # 希望日登録モーダル
  def desired
  end

  # 面談希望日等決定
  def desired_update
    # 希望日登録
    if params[:commit] == "登録"
      @meeting_desired = @teacher.meetings.find_by(child_id: @child.id, desired: true)
      @meeting_desired.update_attributes(desired: false, nottime: nil) if @meeting_desired.present?

      @meeting_child = @teacher.meetings.find_by(child_id: @child.id, date: params[:status])

      @meeting_child.update_attributes(desired: true, nottime: params[:nottime])
      flash[:success] = "希望日を登録しました。"
      redirect_to user_meetings_new_user_url(user_id: @user.id, child_id: @child.id)
    end

    # 可・不可切り替え
    @meeting_children.each do |meeting_child|
      if params[:"#{meeting_child.id}"] == "可"
        @teacher.meetings.find(meeting_child.id).update_attributes(status: 2)
        redirect_to user_meetings_new_user_url(user_id: @user.id, child_id: @child.id)
      elsif params[:"#{meeting_child.id}"] == "不可"
        @teacher.meetings.find(meeting_child.id).update_attributes(status: 3, nottime: nil)
        redirect_to user_meetings_new_user_url(user_id: @user.id, child_id: @child.id)
      end
    end

    # 都合の悪い時間更新
    if params[:commit] == "都合の悪い時間の更新"
      params_count = params.each{|params| params}
      if params_count.count > 8
        @meeting_children.each do |meeting|
          if params[:nottime][meeting.id.to_s]
            meeting.update_attributes(nottime: params[:nottime][meeting.id.to_s])
          end
        end
      end
      flash[:success] = "都合の悪い時間を更新しました。"
      redirect_to user_meetings_new_user_url(user_id: @user.id, child_id: @child.id)
    end

  end

  # 面談スケジュール調整ページ
  def index
    @meetings = @teacher.meetings.all.order(:date)
    @meetings_desired = @teacher.meetings.where(desired: true)
    @meeting_times = @teacher.meeting_times.all
    @desired_count = @teacher.desired_count
    @times_count = @teacher.meeting_times.map{|m| m.time.to_s(:time)}.uniq
    @children = @teacher.children.all
    @meeting_finish_count = 0
    @meeting_times.each{|meeting_time| @meeting_finish_count += 1 unless meeting_time.name.blank?}
    @children_name = @teacher.children_name_array

    if @meetings.first.limit_date_present(limit_date(@meetings.first))
      flash[:info] = "まだ保護者の編集期間中です。"
      redirect_to teacher_meeting_index2_url(@teacher)
    end
  end

  # schedule_updateアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:schedule_update]

  # 面談スケジュール更新
  def schedule_update
    if params[:commit] == "更新"
      if meeting_times_params.present?
        meeting_times_params.each do |key, value|
          meeting_time = MeetingTime.find(key)
          if meeting_time.name.blank?
            meeting_time.update_attributes(name: value[:name])
          elsif value[:name].present?
            meeting_time.update_attributes(name: value[:name])
          end
        end
      end
      flash[:success] = "面談スケジュールを更新しました。"
      redirect_to teacher_meetings_index_url(@teacher)
    end

    if params[:meeting_time_id]
      @meeting_time = @teacher.meeting_times.find(params[:meeting_time_id])
      @meeting_time.update_attributes(name: "")
      flash[:success] = "取り消しました。"
      redirect_to teacher_meetings_index_url(@teacher)
    end
  end

  # 面談状況確認ページ
  def index2
    @children = @teacher.children.all
    @desired_count = 0
    @children.each do |child|
      @desired_count += desired_true_count(@teacher, child.id)
    end
    @teacher = Teacher.find(params[:teacher_id])
    @meetings = @teacher.meetings.all.order(:date)
  end

  private

    # 面談日時レコード更新時に使用
    def meeting_times_params
      params.permit(meeting_times: [:time, :name])[:meeting_times]
    end

    # before_action

    # 現在ログインしている教員本人かどうか
    def correct_teacher
      @teacher = Teacher.find(params[:teacher_id])
      unless current_teacher?(@teacher)
        flash[:danger] = "ユーザー本人しかアクセスできません。"
        redirect_to(root_url)
      end
    end

    # 現在ログインしている保護者かどうか
    def correct_user
      @user = User.find(params[:user_id])
      @child = Child.find(params[:child_id])
      @children = Child.where(user_id: @user.id)
      @teacher = Teacher.find(@child.teacher_id)
      @meeting_children = @teacher.meetings.where(child_id: @child.id)
      @meetings = @teacher.meetings.all.order(:date)
      @meeting_times = @teacher.meeting_times.all
      unless current_user?(@user)
        flash[:danger] = "ユーザー本人しかアクセスできません。"
        redirect_to(root_url)
      end
    end

end
