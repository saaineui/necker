class CreateDatasheets < ActiveRecord::Migration[5.1]
  def change
    create_table :datasheets do |t|
      t.string :name

      t.timestamps
    end
  end
end
