class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name

      t.timestamps
    end

    execute "create index on tags using gin(to_tsvector('english', name));"

    Tag.create(:name => "Dubstep")
    Tag.create(:name => "House")
    Tag.create(:name => "DrumNBass")
  end
end
