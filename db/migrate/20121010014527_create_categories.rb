class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title

      t.timestamps
    end

    Category.create :title => "Dubstep"
    Category.create :title => "Progressive House"
    Category.create :title => "Chill Out"
  end
end
