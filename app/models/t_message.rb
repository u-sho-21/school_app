class TMessage < ApplicationRecord
  belongs_to :teacher

  validates :title,  presence: true, length: { maximum: 20 }
  validates :content,  presence: true, length: { maximum: 100 }
end
