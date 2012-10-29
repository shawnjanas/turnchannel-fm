class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :name
      t.string :remote_id
      t.datetime :last_fetch

      t.timestamps
    end

    forum1 = Forum.create(:remote_id => 3158948)
    ForumPlaylistAssignment.create(:forum_id => forum1.id, :playlist_id => Playlist.where(:title => "New Dubstep").first.id)

    forum2 = Forum.create(:remote_id => 5614319)
    ForumPlaylistAssignment.create(:forum_id => forum2.id, :playlist_id => Playlist.where(:title => "New House").first.id)

    forum3 = Forum.create(:remote_id => 12104873)
    ForumPlaylistAssignment.create(:forum_id => forum3.id, :playlist_id => Playlist.where(:title => "New DrumNBass").first.id)
  end
end
