class Document < ApplicationRecord
  belongs_to :teacher
  has_many :document_items
  has_many :answers
  belongs_to :user
  #バリデーション
  validates :title,presence:true
  validates :memo,presence:true
  validates :deadline,presence:true
end
