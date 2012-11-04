class TrackMixAssignment < ActiveRecord::Base
  attr_accessible :mix_id, :track_id

  belongs_to :mix
  belongs_to :track
end
