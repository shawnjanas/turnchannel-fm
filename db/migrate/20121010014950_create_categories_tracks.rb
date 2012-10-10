class CreateCategoriesTracks < ActiveRecord::Migration
  def change
    create_table :categories_tracks, :id => false do |t|
      t.integer :category_id
      t.integer :track_id

      t.timestamps
    end

    add_index :categories_tracks, :category_id
    add_index :categories_tracks, :track_id
  end
end
