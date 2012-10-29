class CreatePlaylists < ActiveRecord::Migration
  def change
    create_table :playlists do |t|
      t.string :title
      t.integer :user_id

      t.timestamps
    end

    execute "create index on playlists using gin(to_tsvector('english', title));"

    user = User.find_by_email('shawn@turnchannel.com')
    Playlist.create(:title => "New Dubstep", :user_id => user.id)
    Playlist.create(:title => "New House", :user_id => user.id)
    Playlist.create(:title => "New DrumNBass", :user_id => user.id)
  end
end
