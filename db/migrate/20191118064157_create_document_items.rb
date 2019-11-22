class CreateDocumentItems < ActiveRecord::Migration[5.1]
  def change
    create_table :document_items do |t|
      t.text :content
      t.string :randam
      t.references :document, foreign_key: true

      t.timestamps
    end
  end
end
