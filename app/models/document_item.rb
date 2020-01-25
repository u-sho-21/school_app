class DocumentItem < ApplicationRecord
  belongs_to :document
  has_many :document_selects,dependent: :destroy
  validates :content,presence:true,length: { maximum: 50 }

  def select_object
    self.document_selects.all
  end

  def select_non_uniq(parameter)
    selects = self.document_selects.all
    result = true
    selects.each do |select|
      if select.content == parameter
        result = false
        break
      else  
        result = true
      end  
    end
    return result  
  end
  
  
end
