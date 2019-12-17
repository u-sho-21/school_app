class PMessage < ApplicationRecord
  belongs_to :user
  belongs_to :teacher

  validates :title,  presence: true, length: { maximum: 15 }
  validates :content,  presence: true, length: { maximum: 100 }
  validates :reply, length: { maximum: 100 }
end
