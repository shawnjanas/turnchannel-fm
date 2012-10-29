class CreateTrackTagAssignments < ActiveRecord::Migration
  def change
    create_table :track_tag_assignments do |t|
      t.integer :track_id
      t.integer :tag_id

      t.timestamps
    end

    add_index :track_tag_assignments, :track_id
    add_index :track_tag_assignments, :tag_id
  end
end
