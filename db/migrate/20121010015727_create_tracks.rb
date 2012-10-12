class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :artist
      t.integer :source
      t.text :metadata

      t.integer :user_id
      t.timestamps
    end

    add_index :tracks, :source
    add_index :tracks, :user_id
  end
end
