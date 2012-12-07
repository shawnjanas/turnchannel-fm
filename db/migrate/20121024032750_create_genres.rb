class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :source
      t.string :name
      t.string :slug
      t.integer :remote_genre_id

      t.timestamps
    end

    add_index :genres, :slug
    add_index :genres, :remote_genre_id
  end
end
