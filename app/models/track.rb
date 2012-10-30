class Track < ActiveRecord::Base
  attr_accessible :title, :full_title, :plays, :cached_plays, :sc_url, :sc_id, :artwork_url, :purchase_url, :description, :duration, :label_name, :artist, :genre_id, :created_at, :user_id, :tag_id

  has_permalink :full_title

  belongs_to :tag

  validates :sc_url, :presence => true, :uniqueness => true

  before_save :parse_title

  def self.build(user_id, tag, track_hash)
    if track_hash
      if track_hash.stream_url
        track = Track.create(
          :full_title => track_hash.title,
          :sc_url => track_hash.permalink_url,
          :sc_id => track_hash.id,
          :artwork_url => track_hash.artwork_url,
          :purchase_url => track_hash.purchase_url,
          :description => track_hash.description,
          :duration => track_hash.duration,
          :plays => 0,
          :cached_plays => 0,
          :user_id => user_id,
          :tag_id => tag.id
        )
      else
        throw :track_not_streamable
      end
    else
      throw :invalid_track
    end
  end

  def play
    self.plays = self.plays + 1
    self.cached_plays = self.cached_plays + 1
    self.save
  end

  def pre_track
    pre_track_obj = Track.find(:first, :conditions => ["id < ?", self.id], :order => "id DESC") || Track.find(:first, :conditions => ["id >= ?", self.id], :order => "id")

    if pre_track_obj.id == self.id
      Track.all.last.permalink
    else
      pre_track_obj.permalink
    end
  end

  def next_track
    next_track_obj = Track.find(:first, :conditions => ["id > ?", self.id], :order => "id") || Track.find(:first, :conditions => ["id <= ?", self.id], :order => "id DESC")

    if next_track_obj.id == self.id
      Track.all.first.permalink
    else
      next_track_obj.permalink
    end
  end

  def parse_title
    title, *rest = self.full_title.split(/ by /)

    self.title = title
    _rest = rest.join(' by ')
    self.artist = _rest.split(/ - /).first
  end
end
