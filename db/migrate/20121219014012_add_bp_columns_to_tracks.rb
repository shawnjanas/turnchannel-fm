class AddBpColumnsToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :source, :string, :default => 'sc'
    add_column :tracks, :raw_data, :text
    add_column :tracks, :published, :boolean, :default => true

    add_index :tracks, :source
    add_index :tracks, :published
  end
end
