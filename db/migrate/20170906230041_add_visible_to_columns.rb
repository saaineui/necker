class AddVisibleToColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :columns, :visible, :boolean
  end
end
