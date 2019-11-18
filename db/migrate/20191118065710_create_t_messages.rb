class CreateTMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :t_messages do |t|
      t.string :title
      t.text :content
      t.text :reply
      t.string :select_user
      t.references :teacher, foreign_key: true

      t.timestamps
    end
  end
end
