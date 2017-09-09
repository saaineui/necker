class AddTargetSnapshotsToWords < ActiveRecord::Migration[5.1]
  def change
    add_column :words, :nyt_snapshots, :integer, default: 0
    add_column :words, :wsj_snapshots, :integer, default: 0
    add_column :words, :wapo_snapshots, :integer, default: 0
    
    change_column :words, :new_york_times, :integer, default: 0
    change_column :words, :wall_street_journal, :integer, default: 0
    change_column :words, :washington_post, :integer, default: 0
    
    remove_column :words, :cnn
  end
end
