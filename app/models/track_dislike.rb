class TrackDislike < ActiveRecord::Base
  attr_accessible :track_id, :user_id

  belongs_to :track
  belongs_to :user
end
