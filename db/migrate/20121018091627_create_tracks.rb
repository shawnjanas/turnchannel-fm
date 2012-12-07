class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :source
      t.string :name
      t.string :mix_name
      t.string :title
      t.string :slug
      t.string :isrc
      t.string :release_date
      t.string :purchase_url
      t.text :images
      t.integer :duration

      t.string :yt_remote_id
      t.string :yt_artwork_url

      t.integer :plays_count, :default => 0
      t.integer :remote_track_id

      t.integer :label_id

      t.text :searchable_meta
      t.timestamps
    end

    add_index :tracks, :slug
    add_index :tracks, :yt_remote_id, :unique => true

    add_index :tracks, :label_id
    add_index :tracks, :remote_track_id

    execute "create index on tracks using gin(to_tsvector('english', searchable_meta));"
  end
end
