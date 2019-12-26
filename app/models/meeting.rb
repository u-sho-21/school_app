class Meeting < ApplicationRecord
  belongs_to :teacher
  belongs_to :child

  validates :date, presence: true

end
