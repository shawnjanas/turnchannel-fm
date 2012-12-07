class GenreTrackAssignment < ActiveRecord::Base
  attr_accessible :genre_id, :track_id

  belongs_to :genre
  belongs_to :track
end
