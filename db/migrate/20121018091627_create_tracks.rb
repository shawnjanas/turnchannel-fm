class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :full_title
      t.string :artist

      t.string :sc_url
      t.integer :sc_id
      t.string :artwork_url
      t.string :purchase_url

      t.text :description
      t.integer :duration
      t.string :label_name

      t.integer :user_id
      t.integer :tag_id

      t.integer :plays
      t.integer :cached_plays
      t.timestamps
    end

    add_index :tracks, :user_id
    add_index :tracks, :tag_id

    add_index :tracks, :sc_url
    add_index :tracks, :cached_plays

    execute "create index on tracks using gin(to_tsvector('english', full_title));"
  end
end
