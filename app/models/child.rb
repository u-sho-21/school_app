class Child < ApplicationRecord
  belongs_to :teacher
  belongs_to :user
  has_many :meetings, dependent: :destroy
end
