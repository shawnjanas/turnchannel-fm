class Artist < ActiveRecord::Base
  attr_accessible :source, :name, :slug, :last_publish_date, :biography, :images, :remote_artist_id

  has_many :artist_track_assignments
  has_many :tracks, :through => :artist_track_assignments

  def image
    JSON.parse(self.images)['large']['url']
  end

  def self.build(source, artist_hash)
    if source == :bp
      unless (artist = Artist.find_by_remote_artist_id(artist_hash['id']))
        artist = Artist.create(
          :source => 'bp',
          :name => artist_hash['name'],
          :slug => artist_hash['slug'],
          :last_publish_date => artist_hash['lastPublishDate'],
          :biography => artist_hash['biography'],
          :images => artist_hash['images'].to_json,
          :remote_artist_id => artist_hash['id'],
        )
      end
    end
    artist
  end
end
