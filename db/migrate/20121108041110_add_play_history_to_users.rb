class AddPlayHistoryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :play_history, :text, :default => '[]'
  end
end
