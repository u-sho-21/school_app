class User < ApplicationRecord
  attr_accessor :remember_token
  before_save { self.email = email.downcase }
  has_many :answers, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :children, dependent: :destroy
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,  presence: true, length: { maximum: 30 }
  validates :name2, presence: true, length: { maximum: 30 }
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
    if answerData.present?
      return answerData
    end
  end
  
  
  
end
