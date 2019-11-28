class CreateMeetings < ActiveRecord::Migration[5.1]
  def change
    create_table :meetings do |t|
      t.date :date
      t.string :nottime
      t.integer :status, default: 3
      t.boolean :desired, default: false
      t.references :teacher, foreign_key: true
      t.references :child, foreign_key: true

      t.timestamps
    end
  end
end
