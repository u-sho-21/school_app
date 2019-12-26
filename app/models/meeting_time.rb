class MeetingTime < ApplicationRecord
  belongs_to :teacher

  validates :name, uniqueness: true, allow_blank: true
  enum status:{
    default: 0, # 初期
    meeting_decision: 1, # 面談日時決定
    meeting_confirm: 2, # 面談日時確定
  }

end
