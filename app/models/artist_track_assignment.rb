class ArtistTrackAssignment < ActiveRecord::Base
  attr_accessible :artist_id, :track_id

  belongs_to :artist
  belongs_to :track
end
