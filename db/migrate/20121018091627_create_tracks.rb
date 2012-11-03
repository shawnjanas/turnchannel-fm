class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :title
      t.string :source
      t.string :remote_id

      t.string :buy_link
      t.integer :duration

      t.text :thumbnails

      t.integer :plays, :default => 0
      t.timestamps
    end
  end
end
