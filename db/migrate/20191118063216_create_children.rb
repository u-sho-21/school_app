class CreateChildren < ActiveRecord::Migration[5.1]
  def change
    create_table :children do |t|
      t.string :name_1
      t.string :name_2
      t.string :full_name
      t.references :teacher, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
