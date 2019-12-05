class Teacher < ApplicationRecord
  attr_accessor :remember_token
  has_many :meetings
  has_many :meeting_times
  has_many :children
  has_many :t_messages
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
end
