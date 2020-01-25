class TMessage < ApplicationRecord
  belongs_to :teacher

  validates :title,  presence: true, length: { maximum: 20 }
  validates :content,  presence: true, length: { maximum: 100 }

  # 新規お便りチェック
  def new_arrival?
    if self.present?
      created_at + 1.week > Date.today
    end
  end

end
