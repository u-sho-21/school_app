class Document < ApplicationRecord
  has_many :document_items,dependent: :destroy
  has_many :answers,dependent: :destroy
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

  #管理者以外のユーザーでpublic trueになっているかチェック(user 1は管理者のため必要)
  def publicCheck?
    user= User.all.last
    document = user.documents.find_by(memo: self.memo,randam: self.randam)
    if document.nil?
      return true
    else 
      if document.public == true
         return true
      else
         return false   
      end 
    end 
  end
  
end
