class CreateColumns < ActiveRecord::Migration[5.1]
  def change
    create_table :columns do |t|
      t.string :name
      t.references :datasheet, foreign_key: true
    end
    
    create_table :rows do |t|
      t.string :name
      t.references :datasheet, foreign_key: true

      t.timestamps
    end

    create_table :cells do |t|
      t.string :text_val
      t.decimal :float_val
      t.references :column, foreign_key: true
      t.references :row, foreign_key: true

      t.timestamps
    end
  end
end
