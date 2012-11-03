class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name

      t.timestamps
    end

    User.create(:name => 'TurnChannelFM')
  end
end
