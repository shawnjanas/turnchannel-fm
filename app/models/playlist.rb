class Playlist < ActiveRecord::Base
  attr_accessible :title, :user_id

  belongs_to :user

  has_many :track_playlist_assignments
  has_many :tracks, :through => :track_playlist_assignments

  has_many :forum_playlist_assignments
  has_many :forums, :through => :forum_playlist_assignments
end
