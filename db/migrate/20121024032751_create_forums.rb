class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.string :name
      t.string :remote_id
      t.datetime :last_fetch

      t.timestamps
    end

    Forum.create(:remote_id => 3158948)
  end
end
