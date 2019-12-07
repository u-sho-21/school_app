class DocumentItem < ApplicationRecord
  belongs_to :document
  has_many :document_selects,dependent: :destroy
  validates :content,presence:true,length: { maximum: 50 }
end
