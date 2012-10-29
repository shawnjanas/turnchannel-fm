class Track < ActiveRecord::Base
  attr_accessible :title, :full_title, :plays, :sc_url, :sc_id, :artwork_url, :purchase_url, :description, :duration, :label_name, :artist, :genre_id, :created_at, :user_id

  has_many :track_playlist_assignments
  has_many :playlists, :through => :track_playlist_assignments

  validates :sc_url, :presence => true, :uniqueness => true

  before_save :parse_title

  def self.build(user_id, playlists, track_hash)
    if track_hash
      if track_hash.stream_url

        track = Track.create(
          :full_title => track_hash.title,
          :sc_url => track_hash.permalink_url,
          :sc_id => track_hash.id,
          :artwork_url => track_hash.artwork_url,
          :purchase_url => track_hash.purchase_url,
          :description => track_hash.description,
          :duration => track_hash.duration,
          :plays => 0,
          :user_id => user_id
        )

        playlists.each do |playlist|
          TrackPlaylistAssignment.create(:track_id => track.id, :playlist_id => playlist.id)
        end
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
    _rest = rest.join(' by ')
    self.artist = _rest.split(/ - /).first
  end
end
