class CreateMixes < ActiveRecord::Migration
  def change
    create_table :mixes do |t|
      t.string :name
      t.string :source
      t.string :remote_id
      t.text :description

      t.integer :plays_count, :default => 0
      t.integer :likes_count, :default => 0
      t.string :permalink

      t.text :cover_urls

      t.boolean :published
      t.datetime :first_published_at

      t.integer :user_id
      t.timestamps
    end

    add_index :mixes, :user_id
    add_index :mixes, :permalink

    add_index :mixes, [:remote_id, :source], :unique => true

    execute "create index on mixes using gin(to_tsvector('english', name));"
  end
end
