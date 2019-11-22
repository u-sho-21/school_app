class CreateDocuments < ActiveRecord::Migration[5.1]
  def change
    create_table :documents do |t|
      t.string :title
      t.text :memo
      t.text :pdf_link
      t.date :deadline
      t.string :randam
      t.boolean :public, default: false
      t.references :teacher, foreign_key: true
      t.integer :user_id
      t.timestamps
    end
  end
end
