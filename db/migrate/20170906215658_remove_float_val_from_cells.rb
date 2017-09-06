class RemoveFloatValFromCells < ActiveRecord::Migration[5.1]
  def change
    remove_column :cells, :float_val, :decimal
    remove_column :columns, :number, :boolean
  end
end
