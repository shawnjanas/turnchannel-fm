class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title

      t.timestamps
    end

    Category.create :title => "dubstep"
    Category.create :title => "house"
  end
end
