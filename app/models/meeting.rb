class Meeting < ApplicationRecord
  belongs_to :teacher
  belongs_to :child
end