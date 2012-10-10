class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.text :metadata

      t.timestamps
    end

    User.create :name => "Shawn Janas"
  end
end
