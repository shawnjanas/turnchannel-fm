class AddPlaysHistoryAndPlaysWeeklyCountToMixes < ActiveRecord::Migration
  def change
    add_column :mixes, :plays_history, :text, :default => '[0]'
    add_column :mixes, :plays_weekly_count, :integer
    add_column :mixes, :plays_daily_count, :integer
  end
end
