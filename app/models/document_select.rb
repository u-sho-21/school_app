class DocumentSelect < ApplicationRecord
  belongs_to :document_item
  validates :content,presence:true,length: { maximum: 50 }
end
