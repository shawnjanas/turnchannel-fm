class CreateMixes < ActiveRecord::Migration
  def change
    create_table :mixes do |t|
      t.string :name
      t.string :source
      t.string :remote_id
      t.string :description

      t.integer :plays, :default => 0
      t.string :permalink

      t.integer :user_id
      t.timestamps
    end

    add_index :mixes, :user_id
    add_index :mixes, :permalink

    add_index :mixes, [:remote_id, :source], :unique => true

    execute "create index on mixes using gin(to_tsvector('english', name));"
  end
end
