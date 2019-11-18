class CreatePMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :p_messages do |t|
      t.string :title
      t.text :content
      t.text :reply
      t.references :user, foreign_key: true
      t.references :teacher, foreign_key: true

      t.timestamps
    end
  end
end
