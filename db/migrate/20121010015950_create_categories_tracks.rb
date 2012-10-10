class CreateCategoriesTracks < ActiveRecord::Migration
  def change
    create_table :categories_tracks, :id => false do |t|
      t.integer :category_id
      t.integer :track_id

      t.timestamps
    end

    add_index :categories_tracks, :category_id
    add_index :categories_tracks, :track_id

    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/bar9/bar9-midnight', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/nickraymondg/two-door-cinema-club-what-you', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/labrat/m-o-u-break-your-neck-labrat-1', :user_id => 1
    Category.first.tracks.create :source => 0, :remote_url => 'http://soundcloud.com/hollywoodundead/i-dont-wanna-die-borgore', :user_id => 1
  end
end
