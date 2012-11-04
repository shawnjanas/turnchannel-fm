class MixTagAssignment < ActiveRecord::Migration
  def change
    create_table :mix_tag_assignments, :id => false do |t|
      t.integer :mix_id
      t.integer :tag_id
    end

    add_index :mix_tag_assignments, :mix_id
    add_index :mix_tag_assignments, :tag_id
  end
end
