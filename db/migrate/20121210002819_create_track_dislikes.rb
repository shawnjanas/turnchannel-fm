class CreateTrackDislikes < ActiveRecord::Migration
  def change
    create_table :track_dislikes do |t|
      t.integer :user_id
      t.integer :track_id

      t.timestamps
    end

    add_index :track_dislikes, :user_id
    add_index :track_dislikes, :track_id
  end
end
