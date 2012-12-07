class CreateLabels < ActiveRecord::Migration
  def change
    create_table :labels do |t|
      t.string :source
      t.string :name
      t.string :slug
      t.text :biography
      t.text :images
      t.integer :remote_label_id

      t.timestamps
    end

    add_index :labels, :slug
    add_index :labels, :remote_label_id
  end
end
