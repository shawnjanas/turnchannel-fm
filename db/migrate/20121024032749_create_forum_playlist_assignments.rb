class CreateForumPlaylistAssignments < ActiveRecord::Migration
  def change
    create_table :forum_playlist_assignments, :id => false do |t|
      t.integer :forum_id
      t.integer :playlist_id

      t.timestamps
    end

    add_index :forum_playlist_assignments, :forum_id
    add_index :forum_playlist_assignments, :playlist_id
  end
end
