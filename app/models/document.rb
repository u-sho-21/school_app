class Document < ApplicationRecord
  has_many :document_items
  has_many :answers
  belongs_to :user
  #バリデーション
  validates :title,presence:true
  validates :memo,presence:true
  validates :deadline,presence:true
  validate :deadline_check
  #カスタムバリデーション
  
  def deadline_check
    if deadline.presence
      if self.deadline < Date.today 
        errors.add(:deadline,"日付けが過ぎてます。")
      end  
    end  
  end
end
