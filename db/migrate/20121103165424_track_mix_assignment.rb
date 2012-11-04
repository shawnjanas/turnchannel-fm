class TrackMixAssignment < ActiveRecord::Migration
  def change
    create_table :track_mix_assignments, :id => false do |t|
      t.integer :track_id
      t.integer :mix_id
    end

    add_index :track_mix_assignments, :track_id
    add_index :track_mix_assignments, :mix_id
  end
end
