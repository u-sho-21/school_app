class AddSelectitemToDocumentItem < ActiveRecord::Migration[5.1]
  def change
    add_column :document_items, :select_check, :boolean, default:false
  end
end
