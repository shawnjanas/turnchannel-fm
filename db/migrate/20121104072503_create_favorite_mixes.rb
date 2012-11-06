class CreateFavoriteMixes < ActiveRecord::Migration
  def change
    create_table :favorite_mixes do |t|
      t.integer :user_id
      t.integer :mix_id

      t.timestamps
    end

    add_index :favorite_mixes, :user_id
    add_index :favorite_mixes, :mix_id
  end
end
