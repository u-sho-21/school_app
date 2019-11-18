class CreateMeetingTimes < ActiveRecord::Migration[5.1]
  def change
    create_table :meeting_times do |t|
      t.datetime :time
      t.string :name
      t.references :teacher, foreign_key: true

      t.timestamps
    end
  end
end
