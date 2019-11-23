class DocumentSelect < ApplicationRecord
  belongs_to :document_item
  validates :content,presence:true
end
