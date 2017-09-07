class AddLabelIdToDatasheets < ActiveRecord::Migration[5.1]
  def change
    add_column :datasheets, :label_id, :integer
    add_foreign_key :datasheets, :columns, column: :label_id, primary_key: :id
  end
end
