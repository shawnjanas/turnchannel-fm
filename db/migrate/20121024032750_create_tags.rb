class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    execute "create index on tags using gin(to_tsvector('english', name));"

    Tag.create(:name => "dubstep")
    Tag.create(:name => "house")
    Tag.create(:name => "dnb")
  end
end
