class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  has_many :answers, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :children, dependent: :destroy
  has_many :p_messages, dependent: :destroy
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,  presence: true, length: { maximum: 10 }
  validates :name2, presence: true, length: { maximum: 10 }
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :phone, presence: true, length: { maximum: 20 }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  #ユーザーのドキュメントに提出されたものがあるかどうか？
  def documentPublic?
    documents = self.documents.where(public: true)
    if documents.count >0
      return true
    else
      return false
    end  
  end


  #ユーザーとdocumentごとのdocument_item取得
  def userDocumentItem(document)
    obj = self.documents.find_by(memo: document.memo, randam: document.randam)
    items = obj.document_items.all
    return items
  end

  #ユーザーとdocumentごとのanswer取得
  def userAnswers(document)
    obj = self.documents.find_by(memo: document.memo, randam: document.randam)
    answerData = obj.answers.last
    return answerData
    
  end
  #期限切れが全資料かどうか
  def tileLimit?
    result = false
    self.documents.all.each do|document|
      
      if document.deadline < Date.today 
          result = false
      elsif document.deadline > Date.today
          result=true   
          break
      end  
    end  
    return result
  end

  def public_allfalse?
    result = true
    documents = self.documents.where(public: true)
    documents.each do |document|
      if document.public == false
         next
      elsif document.public == true
         result = false
         break
      end 
    end 
    return result 
  end
  
end
