class MeetingsController < ApplicationController
  # before_action :correct_teacher,   only: [:new]

  # 面談日時登録ページ
  def new
    @teacher = Teacher.find(params[:teacher_id])
    @meeting = @teacher.meetings.build
    @meetings = @teacher.meetings.all
    @hour = (0..23).to_a.map { |v| "%02d" % v }
    list = (0..11).to_a.freeze
    @minutes = list.map { |v| v * 5 }
    @frame_list = [1,2,3,4,5,6,7,8]
  end

  # 面談日レコード作成
  def create
    @teacher = Teacher.find(params[:teacher_id])
    if params[:commit] == "登録"
      unless params[:meeting][:date].first.empty?
        Meeting.where(teacher_id: @teacher.id).delete_all
        MeetingTime.where(teacher_id: @teacher.id).delete_all
        params[:meeting][:date].split("\r\n").each do |day|
          unless @teacher.meetings.any? {|meeting| meeting.date == day}
            @teacher.children.where(teacher_id: @teacher.id).each do |child|
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
      @started_time_1 = params[:published_at_hour]
      @started_time_2 = params[:published_at_minute_1]
      @minutes = params[:published_at_minute_2]
      @frame = params[:frame]
      addtime_1 = @started_time_1.to_i
      addtime_2 = @started_time_2.to_i
      @times = times(addtime_1, addtime_2, @frame, @minutes)

      unless @teacher.meetings.any? {|meeting| meeting.date == params[:date]}
        @teacher.children.where(teacher_id: @teacher).each do |child|
          record = @teacher.meetings.build(date: params[:date], child_id: child.id)
          record.save
        end
      end

      @times.each do |time|
        addtime = params[:date] + " #{time}"  # 右側の""内の半角スペースは必要なため消さない
        recode = @teacher.meeting_times.build(time: Time.zone.parse(addtime))
        recode.save
      end
      flash[:success] = "面談日時を追加しました。"
      redirect_to teacher_meetings_edit_url(@teacher)
    end

    if params[:commit] == "初期化"
      Meeting.where(teacher_id: @teacher.id).delete_all
      MeetingTime.where(teacher_id: @teacher.id).delete_all
      flash[:danger] = "面談日程を初期化しました。"
      redirect_to teacher_meetings_new_url
    end
  end

  # 面談日時編集・送信ページ
  def edit
    @teacher = Teacher.find(params[:teacher_id])
    @hour = (0..23).to_a.map { |v| "%02d" % v }
    list = (0..11).to_a.freeze
    @minutes = list.map { |v| v * 5 }
    @frame_list = [1,2,3,4,5,6,7,8]
    @meetings = @teacher.meetings.all
    @meeting_times = @teacher.meeting_times.all
    @times = @teacher.meeting_times.map { |time| time.time }
  end

  # 面談日時レコード更新
  def update
    @teacher = Teacher.find(params[:teacher_id])
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

  # 保護者面談日時登録ページ
  def new_user
    @user = User.find(params[:user_id])
    @children = Child.where(user_id: @user.id)
    @child = Child.find(params[:child_id])
    @teacher = Teacher.find(@child.teacher_id)
    @meeting_children = @teacher.meetings.where(child_id: @child.id)
    @meetings = @teacher.meetings.all
    @meeting_times = @teacher.meeting_times.limit(dates.count)
    @not_time = @meeting_times.map { |time| time.time.to_s(:time) }
  end

  # 希望日登録モーダル
  def desired
    @user = User.find(params[:user_id])
    @child = Child.find(params[:child_id])
    @children = Child.where(user_id: @user.id)
    @teacher = Teacher.find(@child.teacher_id)
    @meetings = @teacher.meetings.all
    @meeting_times = @teacher.meeting_times.limit(dates.count)
    @not_time = @meeting_times.map { |time| time.time.to_s(:time) }
  end

  # 面談希望日等決定
  def desired_update
    @user = User.find(params[:user_id])
    @child = Child.find(params[:child_id])
    @teacher = Teacher.find(@child.teacher_id)

    if params[:commit] == "登録"
      @meeting_desired = @teacher.meetings.find_by(child_id: @child.id, desired: true)
      @meeting_desired.update_attributes(desired: false, nottime: nil)

      @meeting_child = @teacher.meetings.find_by(child_id: @child.id, date: params[:status])

      @meeting_child.update_attributes(desired: true, nottime: params[:nottime])
      flash[:success] = "希望日を登録しました。"
      redirect_to user_meetings_new_user_url(user_id: @user.id, child_id: @child.id)
    end

    @meeting_children = @teacher.meetings.where(child_id: @child.id)
    if params[:true].present?
      if @meeting_children.each{|meeting| params[:true] == meeting.id.to_s}
        @teacher.meetings.find(params[:true].to_s).update_attributes(status: 2)
      end
      redirect_to user_meetings_new_user_url(user_id: @user.id, child_id: @child.id)
    elsif params[:false].present?
      if @meeting_children.each{|meeting| params[:false] == meeting.id.to_s}
        @teacher.meetings.find(params[:false]).update_attributes(status: 3, nottime: nil)
      end
      redirect_to user_meetings_new_user_url(user_id: @user.id, child_id: @child.id)
    else
      redirect_to user_meetings_new_user_url(user_id: @user.id, child_id: @child.id)
    end

    if params[:commit] == "都合の悪い時間の更新"
      @meeting_children = @teacher.meetings.where(child_id: @child.id, desired: false)
      @meeting_children.each do |meeting|
        if params[:nottime][meeting.id.to_s].present?
          meeting.update_attributes(nottime: params[:nottime][meeting.id.to_s])
        end
      end
      flash[:success] = "都合の悪い時間を更新しました。"
      # redirect_to user_meetings_new_user_url(user_id: @user.id, child_id: @child.id)
    end

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

end
