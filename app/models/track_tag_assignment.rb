class TrackTagAssignment < ActiveRecord::Base
  attr_accessible :track_id, :tag_id

  belongs_to :track
  belongs_to :tag
end
