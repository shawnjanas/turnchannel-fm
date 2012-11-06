class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :name
      t.string :artist
      t.string :album_release_name
      t.integer :year

      t.string :source
      t.string :remote_id, :default => nil

      t.text :buy_link
      t.string :buy_icon
      t.integer :duration

      t.text :thumbnails

      t.boolean :published
      t.datetime :first_published_at

      t.integer :plays_count, :default => 0
      t.timestamps
    end

    add_index :tracks, :remote_id, :unique => true
    execute "create index on tracks using gin(to_tsvector('english', name));"
    execute "create index on tracks using gin(to_tsvector('english', artist));"
  end
end
