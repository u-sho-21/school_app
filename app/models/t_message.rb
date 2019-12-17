class TMessage < ApplicationRecord
  belongs_to :teacher

  validates :title,  presence: true, length: { maximum: 15 }
  validates :content,  presence: true, length: { maximum: 100 }
  validates :select_user,  presence: true
end
