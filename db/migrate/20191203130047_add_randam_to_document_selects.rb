class AddRandamToDocumentSelects < ActiveRecord::Migration[5.1]
  def change
    add_column :document_selects, :randam, :string
  end
end
