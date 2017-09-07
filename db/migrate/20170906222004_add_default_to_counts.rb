class AddDefaultToCounts < ActiveRecord::Migration[5.1]
  def change
    change_column :datasheets, :rows_count, :integer, default: 0
    change_column :datasheets, :columns_count, :integer, default: 0
    change_column :rows, :cells_count, :integer, default: 0
  end
end
