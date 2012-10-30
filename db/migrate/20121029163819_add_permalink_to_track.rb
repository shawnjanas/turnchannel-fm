class AddPermalinkToTrack < ActiveRecord::Migration
  def self.up
    add_column :tracks, :permalink, :string
    add_index :tracks, :permalink
  end
  def self.down
    remove_column :tracks, :permalink
  end
end