class AddDurationToMix < ActiveRecord::Migration
  def change
    add_column :mixes, :duration, :integer, :default => 0
    add_column :mixes, :searchable_metadata, :text

    add_index :mixes, :plays_count
    add_index :mixes, :plays_daily_count
    add_index :mixes, :plays_weekly_count

    execute "create index on mixes using gin(to_tsvector('english', searchable_metadata));"
  end
end
