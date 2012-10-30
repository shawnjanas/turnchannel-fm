class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :name
      t.string :remote_id
      t.datetime :last_fetch

      t.integer :tag_id

      t.timestamps
    end

    Forum.create(:remote_id => 3158948, :tag_id => Tag.where(:name => "dubstep").first.id)
    Forum.create(:remote_id => 5614319, :tag_id => Tag.where(:name => "house").first.id)
    Forum.create(:remote_id => 12104873, :tag_id => Tag.where(:name => "dnb").first.id)
  end
end
