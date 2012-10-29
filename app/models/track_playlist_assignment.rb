class TrackPlaylistAssignment < ActiveRecord::Base
  attr_accessible :track_id, :playlist_id

  belongs_to :track
  belongs_to :playlist
end
