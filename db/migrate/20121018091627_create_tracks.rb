class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :full_title

      t.string :sc_url
      t.string :artwork_url
      t.string :purchase_url

      t.text :description
      t.integer :duration
      t.string :label_name

      t.text :raw_data

      t.integer :plays

      t.integer :artist_id
      t.integer :genre_id

      t.timestamps
    end

    add_index :tracks, :artist_id
    add_index :tracks, :genre_id

    execute "create index on tracks using gin(to_tsvector('english', full_title));"
  end
end
