class AddPlaysTrack < ActiveRecord::Migration
  def change
    remove_column :tracks, :cached_plays

    add_index :tracks, :plays

    add_column :tracks, :weekly_plays, :integer, :default => 0
    add_column :tracks, :daily_plays, :integer, :default => 0

    add_index :tracks, :weekly_plays
    add_index :tracks, :daily_plays
  end
end
