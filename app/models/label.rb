class Label < ActiveRecord::Base
  attr_accessible :source, :name, :slug, :biography, :images, :remote_label_id

  def self.build(source, label_hash)
    if source == :bp
      unless (label = Label.find_by_remote_label_id(label_hash['id']))
        label = Label.create(
          :source => 'bp',
          :name => label_hash['name'],
          :slug => label_hash['slug'],
          :biography => label_hash['biography'],
          :images => label_hash['images'].to_json,
          :remote_label_id => label_hash['id'],
        )
      end
    end
    label
  end
end
