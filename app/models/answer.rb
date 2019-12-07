class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :document
  validates :reply,presence:true
end
