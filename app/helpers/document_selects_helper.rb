module DocumentSelectsHelper
  #選択式でdocument#new通過時item_check trueへ 
  def select_check_passage
    document_items = DocumentItem.where(content: @document_item.content,randam: @document_item.randam)
    document_items.each do |item|
      item.update_attributes(select_check: true)
    end  
  end 
  
   
   def document_delete2
     documents = Document.all
     documents.each do |document|
       if document.document_items.all.count >0
         items = document.document_items.all
         items.each do |item|
          #教員ページにてselect_check(入力式入力途中でブラウザ閉じ)trueでdocument_select1以下ならdocument削除
           if item.document_selects.all.count<=1 && item.select_check
              document.destroy
           end 
         end 
          #教員ページにてitem_check(入力式入力途中でブラウザ閉じ)trueでdocument_itemゼロならdocument削除 
       elsif document.document_items.all.count == 0 && document.item_check
         document.destroy
       end  
     end 
   end

   def select_exist
     result = false
     @document.document_items.all.each do |item|
       if item.document_selects.count == 0
         next
       elsif item.document_selects.count > 0
         result = true
       end 
     end 
     return result
   end
   
   
end
