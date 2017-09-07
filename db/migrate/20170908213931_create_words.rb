class CreateWords < ActiveRecord::Migration[5.1]
  def change
    create_table :words do |t|
      t.string :name
      t.string :word
      t.string :match_exp
      t.datetime :start_date
      t.integer :snapshots
      t.integer :new_york_times
      t.integer :wall_street_journal
      t.integer :cnn
      t.integer :washington_post

      t.timestamps
    end
  end
end
