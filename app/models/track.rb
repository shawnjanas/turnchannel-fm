class Track < ActiveRecord::Base
  attr_accessible :name, :artist, :album_release_name, :year, :source, :remote_id, :buy_link, :buy_icon, :duration, :thumbnails, :published, :first_published_at, :plays_count

  validates_presence_of :name, :artist, :source

  has_many :track_mix_assignments
  has_many :mixes, :through => :track_mix_assignments

  def thumbnail
    JSON.parse(self.thumbnails).first['url']
  end
end
