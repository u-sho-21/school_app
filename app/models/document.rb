class Document < ApplicationRecord
  has_many :document_items,dependent: :destroy
  has_many :answers,dependent: :destroy
  
  
  belongs_to :user
  #バリデーション
  validates :title,presence:true,length: { maximum: 50 }
  validates :memo,presence:true,length: { maximum: 100 }
  validates :deadline,presence:true
  #validate :deadline_check
  
  #カスタムバリデーション
  
  def deadline_check
    if deadline.presence
      if self.deadline < Date.today 
        errors.add(:deadline,"日付けが過ぎてます。")
      end  
    end  
  end

  #表示式のみ空禁止
  def view_presence
    if self.document_items.count == 0 && self.service_url.blank?
      errors.add(:self,"必須です。")  
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

  def item_check?
    if self.title.present?
      items = self.document_items.all
      if items.count >0
        return true
      else
        return false
      end   
    end   
  end


end
