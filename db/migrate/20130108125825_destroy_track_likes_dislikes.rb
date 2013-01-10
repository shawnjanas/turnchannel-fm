class DestroyTrackLikesDislikes < ActiveRecord::Migration
  def up
    drop_table :track_likes
    drop_table :track_dislikes
  end

  def down
    create_table :track_likes do |t|
      t.integer :user_id
      t.integer :track_id

      t.timestamps
    end
    create_table :track_dilikes do |t|
      t.integer :user_id
      t.integer :track_id

      t.timestamps
    end
  end
end
