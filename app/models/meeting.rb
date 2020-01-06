class Meeting < ApplicationRecord
  belongs_to :teacher
  belongs_to :child

  validates :date, presence: true

  # 保護者編集期間中かどうか
  def limit_date_present(limit_date)
    Date.today < limit_date || Date.today == limit_date
  end

end
