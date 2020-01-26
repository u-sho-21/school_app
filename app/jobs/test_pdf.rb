class TestPdf < Prawn::Document
    def initialize(id)
      super()

      
      document = Document.find id
      items_input = document.document_items.where(select_check: false)
      items_select = document.document_items.where(select_check: true)


      font_families.update('Test' => { normal: 'vendor/fonts/ipaexm.ttf', bold: 'vendor/fonts/ipaexm.ttf' })
      font 'Test'

      rows = [["#{document.title}"]
          ]
          table rows, cell_style: { height: 40, width: 500, padding: 0 } do
            cells.borders = []
            cells.size = 35
            row(0).background_color = 'ff7500'
            row(0).align = :center
            columns(0).width = 500
          end

      move_down 40
      if items_select.count ==0
        text "*必要事項を記入して教員へ提出ください。", size: 15
      else
        text "*各質問で該当するものを一つ選択し教員へ提出ください。", size: 15  
      end  
      move_down 30
      
      if items_select.count == 0
        items_input.each_with_index do |item,i|
          text "Q#{i+1}.#{item.content}",size: 22
          move_down 20
          rows = [[""]
          ]
          table rows, cell_style: { height: 100, width: 500, padding: 0 } do
            cells.size = 35
            columns(0).width = 500
          end
          move_down 30
        end    

      else
        items_select.each_with_index do |item,i|
            text "Q#{i+1}.#{item.content}",size: 22
            move_down 20
            item.document_selects.each_with_index do |select,i|
                if i == 0
                  rows = [["選択肢","希望するものに◯つけてください。"]
                ]
                table rows, cell_style: { height: 40, width: 500, padding: 0 } do
                cells.size = 20
                row(0).align = :center
                row(0).background_color = 'f0f0f0'
                row(0).size = 15
                row(0).height = 22
                columns(1).row(0).size = 6
                columns(0).width = 450
                columns(1).width = 50
                end
                end  
                rows = [["#{select.content.split(":")[0]}",""]
                ]
                table rows, cell_style: { height: 40, width: 500, padding: 0 } do
                cells.size = 20
                columns(0).width = 450
                columns(1).width = 50
                end
            end    
            move_down 30
        end    

      end
    end
  end