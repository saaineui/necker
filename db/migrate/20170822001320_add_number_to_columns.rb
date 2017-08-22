class AddNumberToColumns < ActiveRecord::Migration[5.1]
  def change
    add_column :columns, :number, :boolean
  end
end
