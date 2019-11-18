class CreateDocumentSelects < ActiveRecord::Migration[5.1]
  def change
    create_table :document_selects do |t|
      t.text :content
      t.references :document_item, foreign_key: true

      t.timestamps
    end
  end
end
