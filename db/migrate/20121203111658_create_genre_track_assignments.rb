class CreateGenreTrackAssignments < ActiveRecord::Migration
  def change
    create_table :genre_track_assignments do |t|
      t.integer :genre_id
      t.integer :track_id

      t.timestamps
    end

    add_index :genre_track_assignments, :genre_id
    add_index :genre_track_assignments, :track_id
  end
end
