module DocumentsHelper
    def select_zerocount?
        result = true
        @document.document_items.all.each do |item|
           if item.document_selects.all.count == 0
              next
           elsif item.document_selects.all.count >=2
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
             #分離できない場合splitの0要素に分割元が格納されるのでこれをもとに分岐
             if array[0] == link
               url =""
               link = ""
               return ""
             else
               view_url = "https://drive.google.com/file/d/"+array[1]+"/preview"
               return view_url
             end  
           elsif url == "One Drive" 
            #<iframe src="https://onedrive.live.com/embed?cid=DB0981266CA942BD&resid=DB0981266CA942BD%2168597&authkey=AG97GvFn2j_nhJQ&em=2" width="476" height="288" frameborder="0" scrolling="no"></iframe>
            array = link.split('"')
             #分離できない場合splitの0要素に分割元が格納されるのでこれをもとに分岐
             if array[0] == link
               url =""
               link = ""
               return ""
             else
               view_url = array[1]
               return view_url
             end  
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

   def selectName(name)
     array = []
     items = DocumentItem.where(content: name)
      items.each do |item|
        item.document_selects.all.each do |select|
          array << select.content
        end  
      end
      array2 = array.uniq  
     return array2
   end    
   def selectCount(select_name)
    user = User.find 1
    user.documents.all.each do |document|
      document.document_items.all.each do |item|
        @select = item.document_selects.find_by(content:select_name).content
      end  
    end  
    
   end

   def answer_count(item)
     array = []
     items = DocumentItem.where(content: item.content, randam: item.randam)
     items.each do |item|
       record = item.document.answers
       if record.count >0
        array << record.reply
       end 
     end
     return array
   end  
   
   def agree_count(number)
     count = 0;
     return count+=number
   end
#集計ページにて選択式があるか確認メソッド

  def select_agree_check
    count = 0
    user = User.find 1
    documents = user.documents.all
    documents.each do |document|
      items = document.document_items.where(select_check: true)
      if items.count > 0
        count += 1
      end 
    end  
    if count > 0
      return true
    else
      return false
    end  
  end
  
  
   
end
