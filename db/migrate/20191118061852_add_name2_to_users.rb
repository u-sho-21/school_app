class AddName2ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :name2, :string
  end
end
