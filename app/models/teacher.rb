class Teacher < ApplicationRecord
  attr_accessor :remember_token
  has_many :meetings
  has_many :meeting_times
  has_many :children
  has_many :documents,dependent: :destroy
  has_many :t_messages, dependent: :destroy
  has_many :p_messages, dependent: :destroy

  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name,  presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def Teacher.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Teacher.new_token
    SecureRandom.urlsafe_base64
  end

  def remember_teacher
    self.remember_token = Teacher.new_token
    update_attribute(:remember_digest, Teacher.digest(remember_token))
  end

  def authenticated_teacher?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget_teacher
    update_attribute(:remember_digest, nil)
  end

  # 面談日時決定
  def meeting_decision_update
    self.meeting_times.update_all(status: :meeting_decision)
  end

  # 面談日時確定
  def meeting_confirm_update
    self.meeting_times.update_all(status: :meeting_confirm)
  end

  # 面談関連のレコードを全て初期化
  def meeting_delete_all
    self.meetings.all.delete_all
    self.meeting_times.all.delete_all
  end

  # 面談返信数カウント
  def desired_count
    self.meetings.where(desired: false).count
  end
end
