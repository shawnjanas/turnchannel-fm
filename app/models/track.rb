class Track < ActiveRecord::Base
  attr_accessible :title, :full_title, :plays, :sc_url, :artwork_url, :purchase_url, :description, :duration, :label_name, :artist, :genre_id, :raw_data

  validates :sc_url, :presence => true, :uniqueness => true

  before_save :parse_title

  def self.build(track_hash)
    if track_hash
      if track_hash.stream_url

        track = Track.create(
          :full_title => track_hash.title,
          :sc_url => track_hash.permalink_url,
          :artwork_url => track_hash.artwork_url,
          :purchase_url => track_hash.purchase_url,
          :description => track_hash.description,
          :duration => track_hash.duration,
          :raw_data => track_hash,
          :plays => 0
        )
      else
        throw :track_not_streamable
      end
    else
      throw :invalid_track
    end
  end

  def parse_title
    title, *rest = self.full_title.split(/ by /)

    self.title = title
    self.artist = rest.join(' by ')
  end
end
