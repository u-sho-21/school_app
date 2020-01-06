module MeetingsHelper

  # 面談日格納(uniq済み)
  def dates
    dates = @meetings.map { |meeting| meeting.date }
    return dates.uniq
  end

  # 面談時間格納
  def times(addtime_1, addtime_2, frame, minutes)
    @times = []
    @times_1 = []
    @times_2 = []
    for i in 0..frame.to_i-1 do
      if i > 0
        addtime_2 += minutes.to_i
        if addtime_2 >= 60 # 60分を超えたら時間繰り上げ
          addtime_1 += 1
          addtime_2 -= 60
          @times_1 << addtime_1.to_s
          @times_2 << addtime_2.to_s
        else
          @times_1 << addtime_1.to_s
          @times_2 << addtime_2.to_s
        end
        @time = format("%02d:%02d", @times_1[i], @times_2[i]) # 0埋めのためにフォーマット
        @times << @time
      else
        @times_1 << addtime_1.to_s
        @times_2 << addtime_2.to_s
        @time = format("%02d:%02d", @times_1[i], @times_2[i]) # 0埋めのためにフォーマット
        @times << @time
      end
    end
    return @times
  end

  # 面談時間のセレクトリスト
  def time_list
    @hour = (0..23).to_a.map { |v| "%02d" % v }
    list1 = (0..11).to_a.freeze
    list2 = (1..11).to_a.freeze
    @minutes_list1 = list1.map { |v| v * 5 }
    @minutes_list2 = list2.map { |v| v * 5 }
    @minutes1 = @minutes_list1.map { |v| "%02d" % v }
    @minutes2 = @minutes_list2.map { |v| "%02d" % v }
    @frame_list = [1,2,3,4,5,6,7,8]
  end

  # 保護者の編集期間
  def limit_date(meetings_first)
    meetings_first.date - 5
  end

  # 保護者の編集期間の現日時からの計算
  def limit_date_count(limit_date)
    (limit_date - Date.today).to_i
  end

  # 予約件数
  def yoyaku_count(teacher, date)
    yoyaku = teacher.meetings.where(date: date , status: 2).count
  end

  # 希望者数
  def desired_count(teacher, date)
    desired = teacher.meetings.where(date: date, desired: true).count
  end

  # 日付別面談時間
  def date_meeting_time(teacher, date)
    date_times = []
    teacher.meeting_times.all.order(:time).each do |meeting_time|
      if meeting_time.time.to_s(:date) == date
        date_times << meeting_time.time.to_s(:time)
      end
    end
    return date_times
  end

  # 都合の悪い時間
  def not_time(meeting)
    if meeting.nottime.nil?
      meeting.nottime = "[]"
    end
    nottime_a = meeting.nottime.split(',').map{|m| m.delete('[]" \\')}
  end

  # 日付別nottimeの選択制限
  def select2_limit(teacher, meeting)
    @teacher.meeting_times.map{|m| m.time.to_s(:time) if m.time.to_s(:date) == meeting.date.to_s(:date)}.compact.count - 1
  end

  # 面談日程の返信状況
  def desired_status(teacher, id)
    meetings = teacher.meetings.where(child_id: id)
    desired = meetings.map{|m| m.desired}
    unless desired.empty?
      case true
        when *desired
          return "返信済み"
        else
          return "未返信"
      end
    else
      return "面談予定なし"
    end
  end

  # 保護者面談 返信数確認
  def desired_true_count(teacher, id)
    meetings = teacher.meetings.where(child_id: id)
    desired = meetings.map{|m| m.desired}
    count = 0
    case true
      when *desired
        count += 1
    end
    return count
  end

  # 面談スケジュールセレクト表示
  def meeting_select(teacher, date, meeting_time)
    meetings = teacher.meetings.where("(status = ?) OR (desired = ?)", 2, true)
    meeting_times = teacher.meeting_times.where.not(name: "")
    names = meeting_times.map{|meeting_time| meeting_time.name}
    child_name = []
    meetings.each do |meeting|
      if meeting.date == date
        if meeting.nottime.nil?
          meeting.nottime = "[]"
        end
        nottime_a = meeting.nottime.split(',').map{|m| m.delete('[]" \\')}

        case meeting_time.time.to_s(:time)
          when *nottime_a
            next
          else
            child_name << Child.find(meeting.child_id).full_name
            names.each{|name| child_name.delete(name)}
        end
      end
    end
    return child_name.compact.reject(&:empty?).uniq
  end

end
