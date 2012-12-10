class CreateTrackLikes < ActiveRecord::Migration
  def change
    create_table :track_likes do |t|
      t.integer :user_id
      t.integer :track_id

      t.timestamps
    end

    add_index :track_likes, :user_id
    add_index :track_likes, :track_id
  end
end
