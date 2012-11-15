class AddPlayHistoryFbUser < ActiveRecord::Migration
  def change
    add_column :users, :play_history, :text, :default => '[]'
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :avatar, :string
  end
end
