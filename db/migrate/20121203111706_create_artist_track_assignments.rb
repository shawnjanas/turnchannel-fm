class CreateArtistTrackAssignments < ActiveRecord::Migration
  def change
    create_table :artist_track_assignments do |t|
      t.integer :artist_id
      t.integer :track_id

      t.timestamps
    end

    add_index :artist_track_assignments, :artist_id
    add_index :artist_track_assignments, :track_id
  end
end
