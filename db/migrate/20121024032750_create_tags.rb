class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    add_index :tags, :name
    execute "create index on tags using gin(to_tsvector('english', name));"
  end
end
