class TMessage < ApplicationRecord
  belongs_to :teacher

  validates :title,  presence: true, length: { maximum: 20 }
  validates :content,  presence: true, length: { maximum: 100 }

  # 新規お便りチェック
  def new_arrival?
    created_at + 1.week > Date.today if created_at.present?
  end

end
