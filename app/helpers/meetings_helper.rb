module MeetingsHelper

  # 面談日格納(uniq済み)
  def dates
    @dates = []
    @meetings.each do |meeting|
      @dates << meeting.date
    end
    return @dates.uniq
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
end
