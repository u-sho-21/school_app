class AddItemcheckToDocument < ActiveRecord::Migration[5.1]
  def change
    add_column :documents, :item_check, :boolean, default:false
    add_column :documents, :service_url, :string
  end
end
