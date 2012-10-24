class Track < ActiveRecord::Base
  attr_accessible :title, :full_title, :plays, :sc_url, :artwork_url, :purchase_url, :description, :duration, :artist_id, :genre_id
end
