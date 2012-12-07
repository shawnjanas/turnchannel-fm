class Genre < ActiveRecord::Base
  attr_accessible :source, :name, :slug, :remote_genre_id

  has_many :genre_track_assignments
  has_many :tracks, :through => :genre_track_assignments
end
