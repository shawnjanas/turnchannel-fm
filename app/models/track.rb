class Track < ActiveRecord::Base
  attr_accessible :title, :artwork_url, :sc_url, :plays, :artist_id, :genre_id
end
