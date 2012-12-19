class AddSourceToForums < ActiveRecord::Migration
  def change
    add_column :forums, :source, :string
  end

  Forum.all.each do |f|
    f.source = 'sc'
    f.save
  end

  Forum.create(:source => 'bp', :name => 'Beatport Dubstep', :remote_id => 18, :tag_id => Tag.where(:name => "dubstep").first.id)
  Forum.create(:source => 'bp', :name => 'Beatport House', :remote_id => 5, :tag_id => Tag.where(:name => "house").first.id)
  Forum.create(:source => 'bp', :name => 'Beatport DnB', :remote_id => 1, :tag_id => Tag.where(:name => "dnb").first.id)
end
