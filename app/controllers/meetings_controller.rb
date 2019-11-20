class MeetingsController < ApplicationController
  # before_action :correct_teacher,   only: [:new]

  # 面談日時登録ページ
  def new
    @teacher = Teacher.find(params[:teacher_id])
    @meeting = @teacher.meetings.build
    @meetings = @teacher.meetings.all
    @hour = (0..23).to_a.map { |v| "%02d" % v }
    @minutes = (0..59).to_a.map { |v| "%02d" % v }
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

      unless @user.meetings.any? {|meeting| meeting.date == params[:date]}
        @user.children.where(user_id: @user).each do |child|
          record = @user.meetings.build(date: params[:date], child_id: child.id)
          record.save
        end
      end

      for i in 0..@times.length-1 do
        addtime = params[:date] + " #{@times[i]}"  # 右側の""内の半角スペースは必要なため消さない
        recode = @user.meeting_times.build(time: Time.zone.parse(addtime))
        recode.save
      end
      redirect_to user_meeting_time_index_url(@user)
    end

    if params[:commit] == "初期化"
      Meeting.where(user_id: @user.id).delete_all
      MeetingTime.where(user_id: @user.id).delete_all
      flash[:danger] = "面談日程を初期化しました。"
      redirect_to new_user_meeting_url
    end
  end

  private

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
