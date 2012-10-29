class CreateTrackPlaylistAssignments < ActiveRecord::Migration
  def change
    create_table :track_playlist_assignments do |t|
      t.integer :track_id
      t.integer :playlist_id

      t.timestamps
    end

    add_index :track_playlist_assignments, :track_id
    add_index :track_playlist_assignments, :playlist_id
  end
end
