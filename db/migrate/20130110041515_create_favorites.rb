class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.integer :user_id
      t.integer :track_id

      t.timestamps
    end

    add_index :favorites, :user_id
    add_index :favorites, :track_id
  end
end
