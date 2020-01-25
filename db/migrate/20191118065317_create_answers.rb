class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.text :reply
      t.string :randam
      t.boolean :select,default:false
      t.references :user, foreign_key: true
      t.references :document, foreign_key: true

      t.timestamps
    end
  end
end
