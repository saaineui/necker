class AddCountsToDatasheets < ActiveRecord::Migration[5.1]
  def change
    add_column :datasheets, :rows_count, :integer
    add_column :datasheets, :columns_count, :integer
    add_column :rows, :cells_count, :integer
  end
end
