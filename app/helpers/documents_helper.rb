module DocumentsHelper
    def select_zerocount?
        result = true
        @document.document_items.all.each do |item|
           if item.document_selects.all.count == 0
              next
           elsif item.document_selects.all.count >0
              result = false
              break
           end 
        end    
          return result
      end
    #外部リンクセレクト用
      def service_select
         @array = ["Google Drive","One Drive"]
      end
    #外部リンク処理  
      def view_url(url,link)
       #ﾘﾝｸが空入力なら
         if link.blank?
           url =""
           link = ""
           return ""  
         else 
           if url == "Google Drive"
             #https://drive.google.com/open?id=1zAOyAZ0bksdecO6Dtn1R6Lir7XGupf9o
             #https://drive.google.com/open?id=14DUd1bx79G-ZBGB0QNwJ9m_vQbxADVsA
             array = link.split("=")
             view_url = "https://drive.google.com/file/d/"+array[1]+"/preview"
             return view_url
           elsif url == "One Drive" 
           end  
         end 
      end
    #answer reply加工
    def reply_view(document)
      array = []
      count = 0  #each文のカウント
      #項目があるか？
      if document.document_items.all.count > 0
        document.document_items.all.each do |item|
          array << item.content.to_s+":"+document.answers.last.reply.split(":")[count].to_s
          count +=1
        end  
        return array
      else
        return nil
      end    
    end
   #日付けチェック
   def document_date_check?(date)
     result = true
     if date.present?
      if Date.parse(date) < Date.today
        result = false
      end 
     end 
     return result
   end
   
   
              
end
