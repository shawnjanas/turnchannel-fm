class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_hash

      t.string :provider, :string
      t.string :users, :uid, :string
      t.string :users, :avatar, :string

      t.timestamps
    end

    User.create(:name => 'TurnChannelFM', :email => 'shawn@turnchannel.com')
  end
end
