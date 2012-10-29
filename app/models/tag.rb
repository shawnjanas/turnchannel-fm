class Tag < ActiveRecord::Base
  attr_accessible :name

  has_many :track_tag_assignments
  has_many :tracks, :through => :track_tag_assignments

  has_many :forums
end
