class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :source
      t.string :remote_id

      t.text :buy_link
      t.integer :duration

      t.text :thumbnails

      t.integer :plays, :default => 0
      t.timestamps
    end

    add_index :tracks, [:remote_id, :source], :unique => true
  end
end
