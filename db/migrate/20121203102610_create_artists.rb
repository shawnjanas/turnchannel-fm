class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :source
      t.string :name
      t.string :slug
      t.string :last_publish_date
      t.text :biography
      t.text :images
      t.integer :remote_artist_id

      t.timestamps
    end

    add_index :artists, :slug
    add_index :artists, :remote_artist_id
  end
end
