class DocumentItem < ApplicationRecord
  belongs_to :document
  has_many :document_selects
  validates :content,presence:true
end
