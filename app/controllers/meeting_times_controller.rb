class MeetingTimesController < ApplicationController


  # 面談時間レコード作成
  def create
    @teacher = Teacher.find(params[:teacher_id])
    @meetings = @teacher.meetings.all
    @started_time_1 = params[:published_at_hour]
    @started_time_2 = params[:published_at_minute_1]
    @minutes = params[:published_at_minute_2]
    @frame = params[:frame]
    addtime_1 = @started_time_1.to_i
    addtime_2 = @started_time_2.to_i

    if params[:commit] == "登録"
      MeetingTime.where(teacher_id: @teacher.id).delete_all
      @times = times(addtime_1, addtime_2, @frame, @minutes)

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
end
