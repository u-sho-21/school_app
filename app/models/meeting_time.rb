class MeetingTime < ApplicationRecord
  belongs_to :teacher

  validates :name, uniqueness: true, allow_blank: true
end
