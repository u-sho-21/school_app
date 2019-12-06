class Child < ApplicationRecord
  belongs_to :teacher
  belongs_to :user
  has_many :meetings, dependent: :destroy

  validates :name_1,  presence: true, length: { maximum: 10 }
  validates :name_2, presence: true, length: { maximum: 10 }
end
