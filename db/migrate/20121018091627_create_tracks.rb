class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :title
      t.integer :plays

      t.string :sc_url
      t.string :artwork_url
      t.string :purchase_url
      t.text :description
      t.integer :duration
      t.string :label_name

      t.text :raw_data

      t.integer :artist_id
      t.integer :genre_id

      t.timestamps
    end
    add_index :tracks, :artist_id
    add_index :tracks, :genre_id
  end
end
